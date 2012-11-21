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

## Generate the documentation

### Download it

    thor docs:download

The GitHub repo of the official docs site will be cloned/updated.

### Generate it

    thor docs:generate

The .json files will be located in /docs/entries.

## Todo
  - check if method is deprecated <entry type="method" name="live" return="jQuery" deprecated="1.7">
  - whats wrong with jQuery.xml long_desc stripping?