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

    jqapi.events.on 'search:done', =>                     # search is complete
      @resultEl.show()                                    # show the result dom list

    jqapi.events.on 'search:clear', =>                    # its requested to clear the field
      @el.val ''                                          # obey
      jqapi.events.trigger 'search:empty'                 # and let anybody know

    jqapi.events.on 'index:done', (e, categories) =>      # wait for the categories to be loaded
      @categories = categories                            # store the cats array

      @el.on 'keyup', (e) =>                              # watch key up on the search field
        @triggerSearch()                                  # and kick it off
        true

    @el.on 'click', => # make that little x on the search input work
      if @el.val().length is 0
        jqapi.events.trigger 'search:clear'

  triggerSearch: ->
    term = @el.val()                                      # cache the current search term

    if term.length is 0                                   # search input is empty
      jqapi.events.trigger 'search:empty'                 # let the app know
    else if term isnt @lastTerm                           # only trigger search if term changed
      @lastTerm = term                                    # save changed search term

      $.doTimeout 'search', 200, =>                       # alaways wait between searches
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

    allResults = @removeDuplicates(allResults)            # remove all duplicates

    @buildResultList allResults, term                     # build the dom list of results

  searchInEntries: (term, entries) ->
    results = []                                          # store results found in entries

    for entry in entries                                  # go through array
      titleLow = entry.title.toLowerCase()                # search in lower case

      if titleLow.indexOf(term) isnt -1                   # search term in title?
        results.push entry                                # if so push entry to array

    results                                               # return result array

  removeDuplicates: (results) ->
    retArr   = []                                         # stripped down array
    checkArr = []                                         # save processed slugs

    for result in results                                 # go through search results with possible duplicates
      if $.inArray(result.slug, checkArr) is -1           # if it isnt already in the check array
        checkArr.push result.slug                         # mark result as processed
        retArr.push result                                # and save the whole object in return array

    retArr                                                # return stripped down array

  buildResultList: (results, term) ->
    notFoundClass = '.not-found'                          # a seperate li inside the results list
    notFoundEl    = $(notFoundClass, @resultEl)           # cache el

    @resultEl.children(":not(#{notFoundClass})").remove() # remove everything except the not found message

    if results.length is 0                                # nothing was found for the search term
      notFoundEl.show()                                   # show not found message
    else                                                  # there are search results
      notFoundEl.hide()                                   # hide not found message

      for result in results                               # for every result
        entryEl = $ templates.entriesItem(result)         # build the template

        
        @resultEl.append entryEl                          # and append it
        $('.title', entryEl).highlight term               # highlight the matching text parts

      @resultEl.children(':odd').addClass 'odd'           # zebra the results

    jqapi.events.trigger 'search:done'                    # let the app know that the search is complete