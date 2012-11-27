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

  before do
    content_type :json
  end
  
  get '/docs/categories.json' do
    serve_file('docs', 'categories.json')
  end

  get '/docs/index.json' do
    serve_file('docs', 'index.json')
  end

  get '/docs/versions.json' do
    serve_file('docs', 'versions.json')
  end

  get '/docs/entries/*.json' do
    serve_file('docs/entries', "#{params[:splat][0]}.json")
  end
  
  get '/' do
    content_type :html
    haml :index
  end

  private
  def serve_file(path, filename)
    filepath = File.join(settings.root, path, filename)

    if File.exists?(filepath)
      File.open(filepath).read
    else
      404
    end
  end
end