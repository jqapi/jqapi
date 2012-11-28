class jqapi.Search
  constructor: ->
    @el         = $ '#search-field'                       # search text input
    @categories = []                                      # loaded categories from json will be stored here

    jqapi.events.on 'index:done', (e, categories) =>      # wait for the categories to be loaded
      @categories = categories                            # store the cats array

      @el.on 'keyup', (e) =>                              # watch key up on the search field
        @search @el.val()                                 # and trigger search with current term

  search: (term) ->
    $.doTimeout 'search', 250, ->                         # alaways wait 250ms between searches
      console.log 'search for', term