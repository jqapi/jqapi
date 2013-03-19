require 'bundler'
Bundler.require

ROOT_DIR = File.join(File.dirname(__FILE__), '..')

class Docs < Thor
  desc 'download', 'pull the official documentation from github'
  def download
    tmpPath   = "#{ROOT_DIR}/tmp"
    clonePath = "#{tmpPath}/api.jquery.com"
    cloneUrl  = 'https://github.com/jquery/api.jquery.com.git'

    unless File.directory?(tmpPath)                       # check if tmp dir exists
      Dir.mkdir(tmpPath)                                  # if not create it
    end

    if %x[which git].length != 0                          # git command exists
      if File.directory?(clonePath)                       # already cloned docs
        puts "Pull from #{clonePath}"
        puts %x[cd #{clonePath} && git pull]              # pull from the github repo
      else                                                # docs repo not cloned yet
        puts "Clone from #{cloneUrl}"
        puts %x[git clone #{cloneUrl} #{clonePath}]       # git clone from the github repo
      end                                                 # no git command found
    else                                                  # no git found
      puts "Please install Git."
    end
  end

  desc 'generate', 'generate documentation in JSON format from the official docs'
  def generate
    xmlPath  = "#{ROOT_DIR}/tmp/api.jquery.com/entries"
    jsonPath = "#{ROOT_DIR}/docs/entries"

    unless File.directory?(xmlPath)                       # docs already downloaded?
      puts "Please run 'thor docs:download' first."
      return
    end

    unless File.directory?(jsonPath)                      # check if destination folder exist
      Dir.mkdir("#{ROOT_DIR}/docs")                       # create parent dir
      Dir.mkdir(jsonPath)                                 # and entries dir
    end

    entries    = parse_xml_entries                        # parse xml files, write files, returns a array of objects
    categories = parse_xml_categories                     # parse categories.xml, write json file, return cats object

    build_index(categories, entries)                      # build the index json

    FileUtils.cp_r "#{xmlPath}/../resources/.", "#{jsonPath}/../resources" # copy resources folder with images
    puts 'Copy resources folder.'

    puts "Done."                                          # phew, everything hopefully set up.
  end                                                     # please go on, nothing to see here


  private
  def parse_xml_entries
    retArr   = []                                         # returns a array of processed entries
    xmlPath  = "#{ROOT_DIR}/tmp/api.jquery.com/entries"
    jsonPath = "#{ROOT_DIR}/docs/entries"

    Dir.glob("#{xmlPath}/*.xml").each do |filepath|       # each .xml file in directory
      contentXml = File.open(filepath).read               # read the xml content of the file

      regex = /<xi:include href="(.+?)".+>/               # including xml xi:include tags
      contentXml = contentXml.gsub regex do            
          icontentXml = File.open("#{xmlPath}/#{$1}").read 
          reg = /<\?xml.*\?>/
          icontentXml = icontentXml.gsub reg , ''      
          icontentXml
        end

      contentObj = Crack::XML.parse(contentXml)           # parse xml to a object
      filename   = filepath.split('/').last.gsub('.xml', '') # get the filename (-selector variation for example)
      entryObj   = {}                                     # will hold entry details, written to file as json

      if contentObj['entries']                            # this file has multiple entries
        entries  = contentObj['entries']['entry']         # the array of variations for this entry
        entryObj = compose_wrapper(entries[0], filename) # use first entry for wrapper infos
        desc     = contentObj['entries']['desc']          # parent description of all entries

        if desc                                           # has a parent short desc
          entryObj[:desc] = desc                          # set the new desc
        end

        entries.each do |entry|                           # go through each entry
          entryContent = compose_entry(entry, contentXml, filename, true) # todo: strip out only entry

          entryObj[:entries].push entryContent            # push to the entries array in wrapper object
        end
      else                                                # this file has one entry
        entry = contentObj['entry']

        entryObj     = compose_wrapper(entry, filename)           # build wrapping object, all the info from the 1st entry
        entryContent = compose_entry(entry, contentXml, filename) # parse first entry

        entryObj[:entries].push entryContent              # push to the entries array in wrapper object
      end

      File.open("#{jsonPath}/#{filename}.json", 'w') do |file|
        file.write entryObj.to_json                       # write json to file
      end

      retArr.push entryObj                                # store entry in the array that returns
      puts "Parsed #{filename}"                           # happy to report
    end

    retArr                                                # return array of processed entries
  end

  def compose_wrapper(entry, filename)
    content    = {
      :name       => entry['name'],                 
      :type       => entry['type'],
      :title      => entry['title'],
      :desc       => entry['desc'],                       # from first entry or from wrapper
      :categories => [],                                  # normalize categories as array
      :entries    => []                                   # all variatons of the method
    }

    if entry['name'] != filename
      content[:slug] = filename                           # set the slug if name is other than filename (-selector)
    end

    entry['category'].each do |cat|                       # simplify the categories array
      content[:categories].push cat['slug']               # add value to simple array
    end

    content                                               # return the entry object
  end

  def compose_entry(entry, entry_raw, filename, include_desc = false)
    content = {                                           # build the final object
      :return     => entry['return'],                     # that will be transformed into json
      :signatures => entry['signature'],
      :examples   => entry['example']
    }

    if include_desc == true                               # this entry has multiple variations
      content[:desc] = entry['desc']                      # so include the desc for a single variation
    end

    content[:longdesc] = strip_long_desc(entry, entry_raw) # try to strip out long description, or empty string
    content                                               # return raw object
  end

  def strip_long_desc(entry, entry_raw)                   # consuming to much crack will result in hacky functions
    entries   = entry_raw.split('<entry ')                # hacky way to go through the raw entries
    long_desc = ''                                        # some entries doesnt have descriptions

    entries.shift                                         # remove first array element (<xml...)

    entries.each do |ent|
      first_line = ent.split("\n").first                  # to check if its the entry we look for

      if first_line.index("type=\"#{entry['type']}\"") != nil && # check for the variation of the method
         first_line.index("name=\"#{entry['name']}\"") != nil &&
         first_line.index("return=\"#{entry['return']}\"") != nil
        
        contStart = ent.index('<longdesc>')               # get the index of the opening tag

        if contStart != nil                               # some entries dont have a desc
          openIndex  = ent.index('<longdesc>') + 10       # get proper start
          closeIndex = ent.index('</longdesc>') - 1       # and end
          long_desc  = ent[openIndex..closeIndex]         # store the raw long_desc
        end

        break                                             # found long_desc, break out, return it
      end
    end

    long_desc                                             # return the html description
  end

  def parse_xml_categories
    retArr     = []                                       # will hold all categories
    contentXml = File.open("#{ROOT_DIR}/tmp/api.jquery.com/categories.xml").read
    contentObj = Crack::XML.parse(contentXml)             # parse xml to a object

    contentObj['categories']['category'].each do |category| # go through the category array
      categoryObj = {                                     # parent category object
        :name => category['name'],
        :slug => category['slug'],
        :desc => category['desc']
      }
      subCats = category['category']                      # some categories have sub categories
      
      if subCats                                          # if so...
        categoryObj[:subcats] = subCats                   # store them to the object, already crackyfied
      end

      retArr.push categoryObj                             # add object to return array
    end

    File.open("#{ROOT_DIR}/docs/categories.json", 'w') do |file|
      file.write retArr.to_json                           # write json to file
    end

    puts 'Parsed catergories.xml'                         # just sayin'
    retArr                                                # return array with cats objects
  end

  def build_category_index(categories)                    # build a simplified category array for the index
    indexArr = []                                         # push the objects to this array

    categories.each do |category|                         # for each category
      subcats      = category[:subcats]                   # category can have sub categories
      subcatsStrip = []                                   # to create the simplified array as well
      catObj       = {                                    # the category object
        :name    => category[:name],
        :slug    => category[:slug],
        :entries => []                                    # parent categiries can have many entries
      }

      if subcats                                          # if the category has sub categories
        subcats.each do |cat|                             # go through each
          subcatsStrip.push({                             # and push the stripped down version
            :name    => cat['name'],
            :slug    => cat['slug'],
            :entries => []                                # a sub categorie can have many entris
          })
        end

        catObj[:subcats] = subcatsStrip                   # store simplified list
      end

      indexArr.push catObj                                # store the parent cat and sub categories
    end

    indexArr                                              # return stripped down version of categories
  end

  def build_index(categories, entries)
    categories = build_category_index(categories)         # build the simplified category object

    entries.each do |entry|                               # fit each entry to categories
      entry[:categories].each do |entry_cat|              # checking every category for every entry
        parts   = entry_cat.split('/')                    # some entries are in sub categories
        sub_cat = false                                   # slug of the sub category if any

        if parts.length == 2                              # included in sub category
          entry_cat = parts[0]                            # set parent category slug
          sub_cat   = parts[1]                            # and sub category slug of entry
        end

        categories.each do |cat|                          # check every category
          if cat[:slug] == entry_cat                      # if the entry matches
            desc     = entry[:desc].gsub(%r{</?[^>]+?>}, '') # remove html from description
                                                          
            if desc.length > 70                           # if the desc is greater that 70 characters
              desc = "#{desc[0..70]}..."                  # cut it down to 70 characters
            end

            entryObj = {                                  # build a new stripped entry obj
              :title => entry[:title],
              :desc  => desc,
              :slug  => entry[:slug] || entry[:name]      # use slug if exist
            }

            if sub_cat                                    # entry is stored in a sub category
              cat[:subcats].each do |subcat|              # find the slug in the subcats
                if subcat[:slug] == sub_cat               # if it matches
                  subcat[:entries].push entryObj          # push entry object to this category's entries array
                end
              end
            else                                          # this entry is stored on the parent category
              cat[:entries].push entryObj                 # store in entries array of parent category
            end
          end
        end
      end
    end

    if categories.last[:slug] == 'version'                # check if last category is version
      versions = categories.pop()                         # remove from categories array

      File.open("#{ROOT_DIR}/docs/versions.json", 'w') do |file|
        file.write versions.to_json                       # write json to file
      end

      puts 'Generated versions.json'
    end

    File.open("#{ROOT_DIR}/docs/index.json", 'w') do |file|
      file.write categories.to_json                       # write json to file
    end

    puts 'Generated index.json'
  end
end