class jqapi.Entry
  constructor: ->
    @el           = $ '#entry'                            # parent element
    @headerHeight = $('#header').height()                 # cache the height of the header navigation

    jqapi.events.on 'entry:load', (e, slug) =>            # entry content must be loaded on this event
      @loadContent slug                                   # find content via the slug

    jqapi.events.on 'window:resize', (e, winEl) =>        # on window resize event
      newHeight = winEl.height() - @headerHeight          # calculate new height

      @el.height newHeight                                # set new height

  loadContent: (slug) ->
    $.getJSON "/docs/entries/#{slug}.json", (data) =>     # fetch from json file
      @parseEntry data                                    # parse what was received
      jqapi.events.trigger 'entry:done', [data]           # let the app know that a new entry is loaded

  parseEntry: (entry) ->
    @el.html templates.entry(entry)

    ###
    codeEl = $ "<pre class='code'>#{entry.entries[0].examples.code}</pre>"
    @el.append codeEl
    codeEl.snippet 'javascript', { showNum: true, menu: false }
    ###