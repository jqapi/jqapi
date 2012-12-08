class jqapi.Entry
  constructor: ->
    @el = $ '#entry'                                      # parent element

    jqapi.events.on 'entry:load', (e, slug) =>            # entry content must be loaded on this event
      @loadContent slug                                   # find content via the slug

  loadContent: (slug) ->
    $.getJSON "/docs/entries/#{slug}.json", (data) =>     # fetch from json file
      @parseEntry data                                    # parse what was received

  parseEntry: (entry) ->
    @el.html templates.entry(entry)


    codeEl = $ "<pre class='code'>#{entry.entries[0].examples.code}</pre>"
    @el.append codeEl
    codeEl.snippet 'javascript', { showNum: true, menu: false }