class jqapi.Keyboard
  constructor: ->
    $(window).on 'keyup', (e) =>                          # on global key press
      if e.keyCode is 27                                  # on ESC key
        jqapi.events.trigger 'search:focus'               # set the focus to the search field