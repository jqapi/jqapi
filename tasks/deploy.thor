class Deploy < Thor
  desc 'generate', 'copys all documentation files and the framework, minifies css and js'

  def generate
    sprockets = Sprockets::Environment.new('')
    deploy_path = 'public'
    assets_path = "#{deploy_path}/assets"

    Jqapi::ASSET_PATHS.each do |path|
      sprockets.append_path(path)
    end

    unless File.directory?(deploy_path)
      Dir.mkdir(deploy_path)
      Dir.mkdir(assets_path)
    end

    sprockets.find_asset('bundle.css').write_to "#{assets_path}/bundle.css"
    puts "Generated (and minified) bundle.css"

    sprockets.find_asset('bundle.js').write_to "#{assets_path}/bundle.js"
    puts "Generated (and minified) bundle.js"

    sprockets.find_asset('jquery.js').write_to "#{assets_path}/jquery.js"
    puts "Keep a copy of jquery.js for offline demos"

    FileUtils.rm_rf "#{deploy_path}/docs"
    FileUtils.cp_r 'docs', "#{deploy_path}/"
    puts 'Copied docs directory'

    FileUtils.rm_rf "#{deploy_path}/resources"
    FileUtils.mv "#{deploy_path}/docs/resources", "#{deploy_path}/resources"
    puts 'Copied resources directory' # you like to juggle?

    %x[cp -r app/assets/images/** #{assets_path}/]
    puts 'Copied images'

    index_haml = File.read("app/views/index.haml")
    index_markup = Haml::Engine.new(index_haml).render

    File.open("#{deploy_path}/index.html", 'w').write(index_markup)
    puts "Generated index.html"

    FileUtils.cp 'LICENSE', "#{deploy_path}/"
    puts "Copied License File"

    FileUtils.cp 'README.md', "#{deploy_path}/"
    puts "Copied Readme File"
  end

  desc 'pack', 'creates a .zip of the standalone version, saved to public/'

  def pack
    FileUtils.rm_f 'public/jqapi.zip'
    %x[cd public/ && zip -r jqapi.zip .]
    puts "Created public/jqapi.zip"
  end

  desc 'air', 'builds a AIR application wrapper, saved to public/'

  def air
    puts "Build AIR wrapper..."
    puts "Cert password: "
    %x[adt -package -storetype pkcs12 -keystore air/jqapi.cert -target air public/jqapi.air air/application.xml -C ./ public/assets public/docs public/resources public/index.html public/LICENSE app/assets/images air/loader.html]
    puts "Done."
  end
end
