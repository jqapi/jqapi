## jQAPI - Alternative jQuery Documentation Browser

This is a revamp of https://github.com/mustardamus/jqapi and still under development.

## Development Environment

The development environment consists of a Sinatra server and a Thor
tool belt.

Served with Sprockets we can use CoffeeScript and SASS. Views will
be written in HAML.

### Requirements

You need to have Ruby and RubyGems installed.

If you don't have already, install Bundler:

    gem install bundler

Then install all the other Gems:

    bundle install

## Generate the documentation

### Download it

    thor docs:download

The GitHub repo of the official docs site will be cloned/updated.

### Generate it

    thor docs:generate

### Start it

    thor dev:start

Point your browser to localhost:9292 and there you have the latest jQuery documentation with jQAPI
wrapped around.

### Generate static files

    thor deploy:generate

Generates index.html, bundle.js, bundle.css, etc., so that the documentation can be
viewed from a set of static files.

## License

Released under MIT & GPL. Coded by Sebastian Senf. http://twitter.com/mustardamus