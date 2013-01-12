class jqapi.Categories
  constructor: ->
    @el  = $ '#categories'                                # parent ul element
    self = @

    jqapi.events.on 'navigation:done', =>                 # call when everything is loaded and generated
      @hideLoader()                                       # hide the loader

    jqapi.events.on 'search:empty', =>                    # on empty search input
      @el.show()                                          # show the general categories list

    jqapi.events.on 'search:done', =>                     # if a search was performed
      @el.hide()                                          # hide the categories list

    jqapi.events.on 'categories:toggle', (e, catEl) =>    # on request to toggle a category
      @toggleCategory catEl                               # toggle the category content

    $.getJSON 'docs/index.json', (data) =>               # load the index json data with all categories and entries
      @buildNavigation data                               # and build from the object when loaded
      jqapi.events.trigger 'index:done', [data]           # let the app know that the index is loaded

    @el.on 'click', '.top-cat-name, .sub-cat-name', ->    # on clicking a category header
      self.toggleCategory $(@).parent()                   # toggle the category
      jqapi.events.trigger 'search:focus'                 # set the lost focus on the search field

  hideLoader: ->                                          # is called when loaded and generated
    @el.children('.loader').remove()                      # simply remove the loader for now

  buildNavigation: (categories) ->                        # build the navigation from the categories array
    for topCat in categories                              # for each parent category
      topCatEl        = $ templates.categoryItem('top', topCat.name) # build the template
      topCatEntriesEl = @buildEntriesList(topCat.entries) # some parent categories have entries
      subCatsEl       = @buildSubcatList(topCat.subcats)  # some have sub categories

      if subCatsEl or topCatEntriesEl                     # only append if there are either sub categories or entries
        topCatEl.append subCatsEl                         # add sub categories
        topCatEl.append topCatEntriesEl                   # add entries
        topCatEl.appendTo @el                             # append parent category object to list

    jqapi.events.trigger 'navigation:done'                # everything done. let anybody know.

  buildEntriesList: (entries) ->                          # build entries list elements for top/sub categories
    el = $ templates.entriesList()                        # get template

    if entries.length                                     # there are entries
      for entry in entries                                # go through each entry
        entryEl = $ templates.entriesItem(entry)          # generate the template

        el.append entryEl                                 # append it to the parent list

      el                                                  # return the generated list element
    else                                                  # no entries found
      false                                               # return false, no need to return a empty list

  buildSubcatList: (subcats) ->                           # building the sub categories list
    el = $ templates.subcatsList()                        # get template

    if subcats and subcats.length                         # are there any sub categories?
      for subcat in subcats                               # for each sub category
        listEl = $ templates.categoryItem('sub', subcat.name) # get template for category

        if subcat.entries.length                          # if the sub category has entries
          listEl.append @buildEntriesList(subcat.entries) # build and append the entries
          listEl.appendTo el                              # append entries list to category

      el                                                  # return list of sub categories with entries
    else                                                  # parent category has no subs
      false                                               # return false

  toggleCategory: (catEl) ->
    catEl.toggleClass 'open'                              # toggle class open on li