## The next version of jQAPI

This is a revamp of https://github.com/mustardamus/jqapi

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

### Start it

    thor dev:start