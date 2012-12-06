class jqapi.Navigate
  constructor: ->
    @sidebarEl     = $ '#sidebar-content'                 # caching the sidebar content el
    @listEl        = $ {}                                 # either categories list or results list
    @hoverClass    = 'hover'                              # deterimine selected item (entry or cat)
    @currentItemEl = []                                   # hold the currently selected item

    @getActiveList()                                      # initially cache current list

    jqapi.events.on 'search:empty', => @getActiveList()   # if the search is empty switch to categories list
    jqapi.events.on 'search:done',  =>
      @getActiveList()                                    # if searched switch to search results list
      @selectFirstItem()                                  # and also select the first item since its a new list

    jqapi.events.on 'navigate:up',    => @prevItem()      # on navigation down request select next item
    jqapi.events.on 'navigate:down',  => @nextItem()      # on navigation down request select next item
    jqapi.events.on 'navigate:enter', => @enterItem()     # on enter open/load the item

  getActiveList: ->
    @listEl        = @sidebarEl.children('ul:visible')    # determine if we are in categories or search results
    @currentItemEl = []                                   # clear the currently selected item on list switch

  prevItem: ->
    @navigateToItem 'prev'                                # navigate to previous item

  nextItem: ->
    @navigateToItem 'next'                                # navigate to next item

  selectFirstItem: ->                                     # nothing selected: select first item
    @currentItemEl = @listEl.children(':visible:first')   # select the first visible child of current list
    @currentItemEl.addClass @hoverClass                   # add the style class

  navigateToItem: (direction) ->
    unless @currentItemEl.length                          # if nothing is selected yet
      @selectFirstItem()                                  # select the first item
      return                                              # nothing more to do

    @currentItemEl.removeClass @hoverClass                # remove class from current item
    @currentItemEl = @currentItemEl[direction]()          # navigate to prev/next item
    @currentItemEl.addClass @hoverClass                   # and set class to new item

  enterItem: ->
    jqapi.events.trigger 'entries:load', [@currentItemEl] # trigger event and let entries handl the loading