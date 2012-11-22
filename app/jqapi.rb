require 'bundler'; Bundler.require

class Jqapi < Sinatra::Base
  set :root,          File.join(File.dirname(__FILE__), '..')
  set :views,         File.join(root, 'app/views')
  set :sprockets,     Sprockets::Environment.new(root)
  set :precompile,    [/\w+\.(?!js|css).+/, /bundle.(css|js)$/]
  set :assets_prefix, 'assets'
  set :assets_path,   File.join(root, 'public', assets_prefix)
  
  asset_paths = [
    'app/assets/javascripts',
    'app/assets/stylesheets',
    'app/assets/images',
    'vendor/assets/javascripts',
    'vendor/assets/stylesheets',
    'vendor/assets/images'
  ]
  
  configure do
    asset_paths.each do |path|
      sprockets.append_path(File.join(root, path))
    end
  end
  
  get '/docs/categories.json' do
    content_type :json
    filepath = File.join(settings.root, 'docs/categories.json')

    File.open(filepath).read
  end

  get '/docs/entries/*.json' do
    content_type :json
    
    filepath = File.join(settings.root, 'docs/entries', "#{params[:splat][0]}.json")

    if File.exists?(filepath)
      File.open(filepath).read
    else
      404
    end
  end
  
  get '/' do
    haml :index
  end
end