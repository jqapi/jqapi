window.jqapi = {}                                         # global object
jqapi.events = $ {}                                       # use application events on a empty jquery object

jQuery ->                                                 # wait for dom ready
  window.templates = new jqapi.Templates                  # shared templates between scripts

  parts = [
    'Sidebar'                                             # responsible for the sidebar dimensions
    'Categories'                                          # loads the index and builds the list
    'Header'                                              # header navigation for different signatures
    'Entries'                                             # handling entries from categories or search results
    'Entry'                                               # loads and inserts a single entry
    'Search'                                              # search and build the results
    'Keyboard'                                            # handle special keys
    'Navigate'                                            # navigates through the categories or search results
  ]

  for part in parts                                       # load the whole application parts
    new jqapi[part]                                       # initialize the part
  
  winEl = $(window)

  winEl
    .resize ->                                            # on window resize
      jqapi.events.trigger 'window:resize', [$(@)]        # trigger a event on the app
    .trigger 'resize'                                     # initially trigger the resize event

  winEl
    .on 'hashchange', ->                                  # on hash change, happens in entry load
      slug = $.bbq.getState('p')                          # slug of requested entry
      jqapi.events.trigger 'entry:load', [slug] if slug   # if the slug is set load the entry
    .trigger 'hashchange'                                 # initially kick it off

  setTimeout ->
    jqapi.events.trigger 'entry:load', ['css']
  , 1000