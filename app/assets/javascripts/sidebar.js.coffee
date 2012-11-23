class jqapi.Sidebar
  constructor: ->
    @el           = $ '#sidebar'                          # outer element, 100% height by css
    @navEl        = $ '#navigation', @el                  # navigation element, this height need to change on resize
    @searchHeight = $('#search', @el).outerHeight()       # getting the height of the search element once
    
    jqapi.events.on 'window:resize', (e, winEl) =>        # on window resize event
      @navEl.height winEl.height() - @searchHeight        # set new height of navigation children