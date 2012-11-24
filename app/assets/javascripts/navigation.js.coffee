class jqapi.Navigation
  constructor: ->
    @el = $ '#navigation'                                 # parent ul element
    
    jqapi.events.on 'navigation:done', => @hideLoader()   # call when everything is loaded and generated
    
    $.getJSON '/docs/index.json', (data) =>               # load the index json data with all categories and entries
      @buildNavigation data                               # and build from the object when loaded

  hideLoader: ->                                          # is called when loaded and generated
    @el.children('.loader').remove()                      # simply remove the loader for now

  buildNavigation: (categories) ->                        # build the navigation from the categories array
    for topCat in categories
      topLi        = $ "<li class='top-cat'>
                          <span class='top-cat-name'>#{topCat.name}</span>      
                        </li>"

      topLi.appendTo @el

    jqapi.events.trigger 'navigation:done'
  
  ###
  appendEntries: (catEl, entries) ->
    entriesIndex = @sortHashKeys entries
    entriesEl    = $ '<ul class="entries" />'

    entriesEl.appendTo catEl
    
    for entryName in entriesIndex
      entry = entries[entryName]
      liEl  = $ "<li class='entry'>
                   <span class='title'>#{entry['title']}</span>
                   <span class='desc'>#{entry['desc']}</span>
                 </li>"
      
      liEl.appendTo entriesEl
      liEl.data 'filename', entryName
      
      entriesEl.children('li:odd').addClass 'odd'

  buildNavigation: (topCats) ->
    topCatsIndex = @sortHashKeys topCats
    
    for topCat in topCatsIndex
      subCats      = topCats[topCat]['subs']
      subCatsIndex = @sortHashKeys subCats
      subCatsEl    = $ '<ul class="sub-cats"/>'
      topLi        = $ "<li class='top-cat'>
                          <span class='top-cat-name'>#{topCat}</span>      
                        </li>"
      
      topLi.appendTo @el
      topLi.append subCatsEl
      @appendEntries topLi, topCats[topCat]['entries']
      
      for subCat in subCatsIndex
        subLi = $ "<li class='sub-cat'>
                    <span class='sub-cat-name'>#{subCat}</span>      
                  </li>"
        
        subCatsEl.append subLi
        @appendEntries subLi, subCats[subCat]
    
    jqapi.events.trigger 'navigation:build'
  
  ###