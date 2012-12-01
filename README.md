## The next version of jQAPI

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

### Start it

    thor dev:start

## Generate the documentation

### Download it

    thor docs:download

The GitHub repo of the official docs site will be cloned/updated.

### Generate it

    thor docs:generate

The .json files will be located in /docs/entries.
Also generated:
  - /docs/categories.json (category names, slugs and full descriptions)
  - /docs/index.json (stripped down category structure with links to entries with stripped down desc)

### index.json Structure

    [
      {
        "name": "Ajax",
        "slug": "ajax",
        "entries": [],
        "subcats": [
            {
              "name": "Global Ajax Event Handlers",
              "slug": "global-ajax-event-handlers",
              "entries": [
                {
                  "title": ".ajaxComplete()",
                  "desc": "Register a handler to be called when Ajax requests complete. This is an AjaxEvent.",
                  "slug": "ajaxComplete"
                },
                ...
          ]
          }
        ]
      },
      {
        "name": "Attributes",
        "slug": "attributes",
        "entries": [
          {
            "title": ".addClass()",
            "desc": "Adds the specified class(es) to each of the set of matched elements.",
            "slug": "addClass"
          },
          ...
        ]
      },
      ...
    ]

### categories.json Structure

    [
      {
        "name": "Ajax",
        "slug": "ajax",
        "desc": "The jQuery library has ...",
        "subcats": [
          {
            "desc": "These methods register ...",
            "name": "Global Ajax Event Handlers",
            "slug": "global-ajax-event-handlers"
          },
          {
            "desc": "These functions assist ...",
            "name": "Helper Functions",
            "slug": "helper-functions"
          },
          ...
        ]
      },
      {
        "name": "Attributes",
        "slug": "attributes",
        "desc": "These methods get and set DOM attributes of elements."
      },
      {
        "name": "Callbacks Object",
        "slug": "callbacks-object",
        "desc": "The <code>jQuery.Callbacks()</code> function ..."
      },
      ...
    ]

### Entry JSON Structure

    {
      "name": "css",
      "type": "method",
      "title": ".css()",
      "desc": "Get the value of ...",
      "categories": [
        "css",
        "manipulation/style-properties",
        "version/1.0",
        "version/1.4"
      ],
      "entries": [
        {
          "return": "String",
          "signatures": {
            "added": "1.0",
            "argument": {
            "desc": "A CSS property.",
            "name": "propertyName",
            "type": "String"
          }
          },
          "examples": {
            "desc": "To access the background color of a clicked div.",
            "code": "...",
            "css": "...",
            "html": "..."
          },
          "desc": "..."
        },
        {
          "return": "jQuery",
          "signatures": [
            {
              "added": "1.0",
              "argument": [
                {
                  "desc": "A CSS property name.",
                  "name": "propertyName",
                  "type": "String"
                },
                {
                  "desc": "A value to set for the property.",
                  "name": "value",
                  "type": "String, Number"
                }
              ]
            },
            {
              "added": "1.4",
              "argument": [
                {
                  "desc": "A CSS property name.",
                  "name": "propertyName",
                  "type": "String"
                },
                {
                  "desc": "A function ...",
                  "name": "function(index, value)",
                  "type": "Function"
                }
              ]
            },
            {
              "added": "1.0",
              "argument": {
                "desc": "A map of property-value pairs to set.",
                "name": "properties",
                "type": "PlainObject"
              }
            }
          ],
          "examples": [
            {
              "desc": "...",
              "code": "...",
              "css": "...",
              "html": "..."
            },
            ...
          ],
          "desc": "..."
        }
      ]
    }

## Todo
  - check if method is deprecated <entry type="method" name="live" return="jQuery" deprecated="1.7">
  - whats wrong with jQuery.xml long_desc stripping?
  - there is nothing in the 'Uncategorized' categegory. check if there are entries and/or subcats.
  - cross browser css3
  - unify category and search results navigation, style via parent