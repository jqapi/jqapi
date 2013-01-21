class jqapi.Sidebar
  constructor: ->
    @el           = $ '#sidebar'                          # outer element, 100% height by css
    @contentEl    = $ '#sidebar-content', @el             # navigation element, this height need to change on resize
    @searchHeight = $('#search', @el).outerHeight()       # getting the height of the search element once
    
    jqapi.events.on 'window:resize', (e, winEl) =>        # on window resize event
      newHeight = winEl.height() - @searchHeight          # calculate new height

      @contentEl.height newHeight                         # set new height of sidebar content

    @el.on 'mouseenter', =>                               # if the mouse enters the sidebar area
      unless helper.isMobile()                            # don't set focus on mobile devices
        jqapi.events.trigger 'search:focus'               # set focus to search input