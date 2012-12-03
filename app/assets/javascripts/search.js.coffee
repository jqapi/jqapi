class jqapi.Search
  constructor: ->
    @el         = $ '#search-field'                       # search text input
    @resultEl   = $ '#results'                            # seperate list to show search results
    @categories = []                                      # loaded categories from json will be stored here
    @lastTerm   = ''                                      # keep track of the last search term

    jqapi.events.on 'search:focus', =>                    # receive event when to set focus
      @el.focus()                                         # and do it

    jqapi.events.on 'search:empty', =>                    # on empty search input
      @resultEl.hide()                                    # hide the results list

    jqapi.events.on 'index:done', (e, categories) =>      # wait for the categories to be loaded
      @categories = categories                            # store the cats array

      @el.on 'keyup', (e) =>                              # watch key up on the search field
        @triggerSearch()                                  # and kick it off

  triggerSearch: ->
    term = @el.val()                                      # cache the current search term

    if term.length is 0                                   # search input is empty
      jqapi.events.trigger 'search:empty'                 # let the app know
    else if term isnt @lastTerm                           # only trigger search if term changed
      @lastTerm = term                                    # save changed search term

      $.doTimeout 'search', 250, =>                       # alaways wait 250ms between searches
        @search term                                      # and trigger search with current term

  search: (term) ->
    allResults = []                                       # store matching objects in here

    for topCat in @categories                             # search in every parent category
      if topCat.entries and topCat.entries.length         # if the parent category has entries
        result     = @searchInEntries(term, topCat.entries) # search in the entries array
        allResults = allResults.concat(result)            # concat to all results
      
      if topCat.subcats and topCat.subcats.length         # if the parent category has sub categories
        for subCat in topCat.subcats                      # go through it
          if subCat.entries.length                        # if there are entries
            result     = @searchInEntries(term, subCat.entries) # search in there as well
            allResults = allResults.concat(result)        # concat array with results found in subcat

    @buildResultList allResults                           # build the dom list of results

  searchInEntries: (term, entries) ->
    results = []                                          # store results found in entries

    for entry in entries                                  # go through array
      titleLow = entry.title.toLowerCase()                # search in lower case

      if titleLow.indexOf(term) isnt -1                   # search term in title?
        results.push entry                                # if so push entry to array

    results                                               # return result array

  buildResultList: (results) -> #ey, work in progress
    @resultEl.empty()

    for r in results
      @resultEl.append templates.entriesItem(r)

    @resultEl.children(':odd').addClass 'odd'
    
    @resultEl.show()
    $('#categories').hide()