require 'json'
require 'crack'

ROOT_DIR = File.join(File.dirname(__FILE__), '..')

class Docs < Thor
  desc 'download', 'pull the official documentation from github'
  def download
    tmpPath   = "#{ROOT_DIR}/tmp"
    clonePath = "#{tmpPath}/api.jquery.com"
    cloneUrl  = 'https://github.com/jquery/api.jquery.com.git'

    unless File.directory?(tmpPath)                 # check if tmp dir exists
      Dir.mkdir(tmpPath)                            # if not create it
    end

    if %x[which git].length != 0                    # git command exists
      if File.directory?(clonePath)                 # already cloned docs
        puts "Pull from #{clonePath}"
        puts %x[cd #{clonePath} && git pull]        # pull from the github repo
      else                                          # docs repo not cloned yet
        puts "Clone from #{cloneUrl}"
        puts %x[git clone #{cloneUrl} #{clonePath}] # git clone from the github repo
      end
    else                                            # no git found
      puts "Please install Git."
    end
  end

  desc 'generate', 'generate documentation in JSON format from the official docs'
  def generate
    xmlPath  = "#{ROOT_DIR}/tmp/api.jquery.com/entries"
    jsonPath = "#{ROOT_DIR}/docs/entries"

    unless File.directory?(xmlPath)                 # docs already downloaded?
      puts "Please run 'thor docs:download' first."
      return
    end

    unless File.directory?(jsonPath)                # check if destination folder exist
      Dir.mkdir("#{ROOT_DIR}/docs")                 # create parent dir
      Dir.mkdir(jsonPath)                           # and entries dir
    end

    Dir.glob("#{xmlPath}/*.xml").each do |filepath| # each .xml file in directory
      contentXml = File.open(filepath).read         # read the xml content of the file
      contentObj = Crack::XML.parse(contentXml)     # parse xml to a object
      filename   = filepath.split('/').last.gsub('.xml', '') # get the filename (-selector variation for example)
      entryObj   = {}                               # will hold entry details, written to file as json

      if contentObj['entries']                      # this file has multiple entries
        entries  = contentObj['entries']['entry']   # the array of variations for this entry
        entryObj = compose_wrapper(entries[0], filename) # use first entry for wrapper infos
        desc     = contentObj['entries']['desc']    # parent description of all entries

        if desc                                     # has a parent short desc
          entryObj[:desc] = desc                    # set the new desc
        end

        entries.each do |entry|                     # go through each entry
          entryContent = compose_entry(entry, contentXml, filename, true) # todo: strip out only entry

          entryObj[:entries].push entryContent      # push to the entries array in wrapper object
        end
      else                                          # this file has one entry
        entry = contentObj['entry']

        entryObj     = compose_wrapper(entry, filename)           # build wrapping object, all the info from the 1st entry
        entryContent = compose_entry(entry, contentXml, filename) # parse first entry

        entryObj[:entries].push entryContent        # push to the entries array in wrapper object
      end

      File.open("#{jsonPath}/#{filename}.json", 'w') do |file|
        file.write entryObj.to_json                 # write json to file
      end

      puts "Parsed #{filename}"                     # happy to report
    end
  end

  private
  def compose_wrapper(entry, filename)
    content    = {
      :name    => entry['name'],                 
      :type    => entry['type'],
      :title   => entry['title'],
      :desc    => entry['desc'], #from first entry or use default
      :categories => [],                            # normalize categories as array
      :entries => []                                # all variatons of the method
    }

    if entry['name'] != filename
      content[:slug] = filename                     # set the slug if name is other than filename (-selector)
    end

    entry['category'].each do |cat|                 # simplify the categories array
      content[:categories].push cat['slug']         # add value to simple array
    end

    content                                         # return the entry object
  end

  def compose_entry(entry, entry_raw, filename, include_desc = false)
    content = {                                     # build the final object
      :return     => entry['return'],               # that will be transformed into json
      :signatures => entry['signature'],
      :examples   => entry['example']
    }

    if include_desc == true                         # this entry has multiple variations
      content[:desc] = entry['desc']                # so include the desc for a single variation
    end

    content[:longdesc] = strip_long_desc(entry, entry_raw) # try to strip out long description, or empty string

    content                                         # return raw object
  end

  def strip_long_desc(entry, entry_raw)             # consuming to much crack will result in hacky functions
    entries   = entry_raw.split('<entry ')          # hacky way to go through the raw entries
    long_desc = ''                                  # some entries doesnt have descriptions

    entries.shift                                   # remove first array element (<xml...)

    entries.each do |ent|
      first_line = ent.split("\n").first            # to check if its the entry we look for

      if first_line.index("type=\"#{entry['type']}\"") != nil && # check for the variation of the method
         first_line.index("name=\"#{entry['name']}\"") != nil &&
         first_line.index("return=\"#{entry['return']}\"") != nil
        
        contStart = ent.index('<longdesc>')         # get the index of the opening tag

        if contStart != nil                         # some entries dont have a desc
          openIndex  = ent.index('<longdesc>') + 10 # get proper start
          closeIndex = ent.index('</longdesc>') - 1 # and end
          long_desc  = ent[openIndex..closeIndex]   # store the raw long_desc
        end

        break                                       # found long_desc, break out, return it
      end
    end

    long_desc                                       # return the html description
  end
end