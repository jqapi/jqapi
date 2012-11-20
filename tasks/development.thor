class Dev < Thor
  desc 'start', 'start the development sinatra server'
  def start
    %x[bundle exec rackup]
  end
end