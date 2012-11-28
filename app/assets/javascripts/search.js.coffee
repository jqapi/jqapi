class jqapi.Search
  constructor: ->
    @el         = $ '#search-field'                       # search text input
    @categories = []                                      # loaded categories from json will be stored here

    jqapi.events.on 'index:done', (e, categories) =>      # wait for the categories to be loaded
      @categories = categories                            # store the cats array

      # init keyup on search field