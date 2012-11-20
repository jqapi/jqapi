require "#{File.dirname(__FILE__)}/app/jqapi.rb"

map '/assets' do
  run Jqapi.sprockets
end

map '/' do
  run Jqapi
end