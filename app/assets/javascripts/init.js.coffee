window.jqapi = {}                                         # global object
jqapi.events = $ {}                                       # use application events on a empty jquery object

jQuery ->                                                 # wait for dom ready
  new jqapi.Sidebar                                       # responsible for the sidebar dimensions
  new jqapi.Navigation                                    # loads the index and builds the list
  new jqapi.Content                                       # loads and inserts content
  
  $(window)
    .resize ->                                            # on window resize
      jqapi.events.trigger 'window:resize', [$(@)]        # trigger a event on the app
    .trigger 'resize'                                     # initially trigger the resize event