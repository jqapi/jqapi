class jqapi.Header
  constructor: ->
    @el = $ '#header'                                     # parent element

    @el.height $('#search').height()                      # set the same height as the search box has