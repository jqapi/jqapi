class jqapi.Content
  constructor: ->
    @el = $ '#content'                                    # parent element

    jqapi.events.on 'content:load', (e, slug) =>          # content must be loaded on this even
      @loadContent slug                                   # find content via the slug

  loadContent: (slug) ->
    $.getJSON "/docs/entries/#{slug}.json", (data) =>     # fetch from json file
      @parseContent data                                  # parse what was received

  parseContent: (entry) ->
    @el.html templates.content(entry)