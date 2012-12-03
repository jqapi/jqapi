class jqapi.Entries
  constructor: ->
    @el = $ '#sidebar-content'                            # parent element of category and search result lists

    @el.on 'click', '.entry', ->                          # on clicking a single entry
      el       = $ @                                      # caching
      activeEl = $('.active', @el)                        # last clicked element

      unless el.is(activeEl)                              # unless it is the same elent thats already active
        activeEl.removeClass 'active'                     # remove active class from recent el
        el.addClass 'active'                              # add it to the clicked entry

        jqapi.events.trigger 'content:load', el.data('slug') # let jqapi.Content know to load some content, pass slug
        jqapi.events.trigger 'search:focus'               # set the lost focus on the search field