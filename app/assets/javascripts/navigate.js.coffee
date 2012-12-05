class jqapi.Navigate
  constructor: ->
    @sidebarEl = $ '#sidebar-content'                     # caching the sidebar content el
    @listEl    = $ {}                                     # either categories list or results list

    @getActiveList()                                      # initially cahce current list

    jqapi.events.on 'search:empty', => @getActiveList()   # if the search is empty switch to categories list
    jqapi.events.on 'search:done',  => @getActiveList()   # if searched switch to categories list

    jqapi.events.on 'navigate:down', =>
      console.log @listEl.attr('id')

  getActiveList: ->
    @listEl = @sidebarEl.children('ul:visible')           # determine if we are in categories or search results