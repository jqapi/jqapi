window.jqapi = {}                                         # global object
jqapi.events = $ {}                                       # use application events on a empty jquery object

jQuery ->                                                 # wait for dom ready
  window.templates = new jqapi.Templates                  # shared templates between scripts
  
  new jqapi.Sidebar                                       # responsible for the sidebar dimensions
  new jqapi.Categories                                    # loads the index and builds the list
  new jqapi.Entries                                       # handling entries from categories or search results
  new jqapi.Content                                       # loads and inserts content
  new jqapi.Search                                        # search and build the results
  new jqapi.Keyboard                                      # handle special keys
  new jqapi.Navigate                                      # navigates through the categories or search results
  
  $(window)
    .resize ->                                            # on window resize
      jqapi.events.trigger 'window:resize', [$(@)]        # trigger a event on the app
    .trigger 'resize'                                     # initially trigger the resize event