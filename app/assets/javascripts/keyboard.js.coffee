class jqapi.Keyboard
  constructor: ->
    $(window).on 'keyup', (e) =>                          # on global key press
      if e.keyCode is 27                                  # on ESC key
        jqapi.events.trigger 'search:focus'               # set the focus to the search field

    $('#search-field').on 'keyup', (e) =>                 # on keypress in input field
      switch e.keyCode                                    # check on the keycode
        when 27 # ESC
          jqapi.events.trigger 'search:clear'             # clear the input on escape
        when 38 # UP
          jqapi.events.trigger 'navigate:up'              # let the app know the user want to navigate up
        when 40 # DOWN
          jqapi.events.trigger 'navigate:down'            # or down
        when 13 # ENTER
          jqapi.events.trigger 'navigate:enter'           # user wants to open category or see entry