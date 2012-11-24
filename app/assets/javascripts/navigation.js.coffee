class jqapi.Navigation  
  constructor: ->
    @el = $ '#navigation'                                 # parent ul element
    
    jqapi.events.on 'navigation:done', => @hideLoader()   # call when everything is loaded and generated
    
    $.getJSON '/docs/index.json', (data) =>               # load the index json data with all categories and entries
      @buildNavigation data                               # and build from the object when loaded

  hideLoader: ->                                          # is called when loaded and generated
    @el.children('.loader').remove()                      # simply remove the loader for now

  buildNavigation: (categories) ->                        # build the navigation from the categories array
    for topCat in categories                              # for each parent category
      topCatEl        = $ @templateCategory('top', topCat.name) # build the template
      topCatEntriesEl = @buildEntriesList(topCat.entries) # some parent categories have entries
      subCatsEl       = @buildSubcatList(topCat.subcats)  # some have sub categories

      topCatEl.append subCatsEl       if subCatsEl        # add sub categories if any
      topCatEl.append topCatEntriesEl if topCatEntriesEl  # add entries if any
      topCatEl.appendTo @el                               # append parent category object to list

    jqapi.events.trigger 'navigation:done'                # everything done. let anybody know.

  buildEntriesList: (entries) ->                          # build entries list elements for top/sub categories
    el = $ @templateEntriesList()                         # get template

    if entries.length                                     # there are entries
      for entry in entries                                # go through each entry
        entryEl = $ @templateEntriesItem(entry)           # generate the template

        el.append entryEl                                 # append it to the parent list

      el.children('li:odd').addClass 'odd'                # set a odd class to children
      el                                                  # return the generated list element
    else                                                  # no entries found
      false                                               # return false, no need to return a empty list

  buildSubcatList: (subcats) ->                           # building the sub categories list
    el = $ @templateSubcatsList()                         # get template

    if subcats and subcats.length                         # are there any sub categories?
      for subcat in subcats                               # for each sub category
        listEl = $ @templateCategory('sub', subcat.name)  # get template for category

        if subcat.entries.length                          # if the sub category has entries
          listEl.append @buildEntriesList(subcat.entries) # build and append the entries

        listEl.appendTo el                                # append entries list to category

      el                                                  # return list of sub categories with entries
    else                                                  # parent category has no subs
      false                                               # return false

  templateCategory: (pos, name) ->
    """
    <li class='#{pos}-cat'>
      <span class='#{pos}-cat-name'>#{name}</span>
    </li>
    """

  templateEntriesList: ->
    '<ul class="entries" />'

  templateEntriesItem: (entry) ->
    """
    <li class='entry' data-slug='#{entry.slug}'>
      <span class='title'>#{entry.title}</span>
      <span class='desc'>#{entry.desc}</span>
    </li>
    """

  templateSubcatsList: ->
    '<ul class="sub-cats" />'