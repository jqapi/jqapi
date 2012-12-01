class jqapi.Sidebar
  constructor: ->
    @el           = $ '#sidebar'                          # outer element, 100% height by css
    @navEl        = $ '#navigation', @el                  # navigation element, this height need to change on resize
    @resultsEl    = $ '#results', @el                     # results are a seperated list and needs to be resized too
    @searchHeight = $('#search', @el).outerHeight()       # getting the height of the search element once
    
    jqapi.events.on 'window:resize', (e, winEl) =>        # on window resize event
      newHeight = winEl.height() - @searchHeight          # calculate new height

      @navEl.height newHeight                             # set new height of navigation children
      @resultsEl.height newHeight                         # same with result list