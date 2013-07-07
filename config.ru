require "#{File.dirname(__FILE__)}/app/jqapi.rb"

map '/assets' do
  run Jqapi::Server.sprockets
end

map '/' do
  run Jqapi::Server
end
