class jqapi.Entry
  constructor: ->
    @el           = $ '#entry'                            # parent element
    @headerHeight = $('#header').outerHeight()            # cache the height of the header navigation

    jqapi.events.on 'entry:load', (e, slug) =>            # entry content must be loaded on this event
      @el.scrollTop 0                                     # scroll the element back to top
      @loadContent slug                                   # find content via the slug
      $.bbq.pushState { p: slug }                         # set the new hash state with old #p= format

    jqapi.events.on 'window:resize', (e, winEl) =>        # on window resize event
      newHeight = winEl.height() - @headerHeight          # calculate new height

      @el.height newHeight                                # set new height

  loadContent: (slug) ->
    $.getJSON "/docs/entries/#{slug}.json", (data) =>     # fetch from json file
      @parseEntry data                                    # parse what was received
      jqapi.events.trigger 'entry:done', [data]           # let the app know that a new entry is loaded

  parseEntry: (entry) ->
    el = $ templates.entry(entry)                         # generate element from template
    
    #@insertCategories entry, el                           # generate and insert categories
    @insertEntries    entry, el                           # generate entries and insert

    @el.html el                                           # set the new html content
    @highlightCode()
    @fixLinks()

  insertCategories: (entry, el) ->
    catsEl  = $('#categories', el)                        # cache categories list

    for cat in entry.categories                           # go through the category array
      continue if cat.substr(0, 7) is 'version'           # skip the version categories
      catsEl.append "<li>#{cat}</li>"

  insertEntries: (entry, el) ->
    entriesEl = $('#entries', el)                         # cache entries list

    for ent in entry.entries                              # go through every entry
      entryEl = $ templates.entryEntriesItem(ent)         # build element from template

      @insertSignatures entry, ent, entryEl               # insert all signatures for a entry
      @insertExamples ent.examples, entryEl               # insert the demos
      entriesEl.append entryEl                            # append entry to the parent list

  insertSignatures: (parentEntry, entry, el) ->
    signatures = entry.signatures                         # can be a single object
    signatures = [signatures] unless $.isArray(signatures) # if so turn it into a array
    sigsEl     = $('.signatures', el)                     # cache signatures el

    for sig in signatures
      sigTitle = @getSignatureTitle(parentEntry.title, sig) # generate the title with arguments if any
      sigEl    = $ templates.signaturesItem(sigTitle, entry.return, sig.added) # build el from template

      @insertArguments sig, sigEl                         # insert arguments list

      sigsEl.append sigEl                                 # append to parent list element

  getSignatureTitle: (title, signature) ->
    sigTitle = title                                      # selector titles must not be altered

    if title.substr(title.length - 2) is '()'             # if its a function
      argsArr = signature.argument                        # can be a single object
      argsArr = [argsArr] unless $.isArray(argsArr)       # if so turn it into a array
      joinArr = []                                        # generate the comma seperated string with join

      for arg in argsArr
        joinArr.push arg.name if arg and arg.name         # push argument name to join array

      methodName = title.substr(0, title.length - 2)      # cut out the empty ()
      sigTitle   = "#{methodName}(#{joinArr.join(', ')})" # and fill it with arguments

    sigTitle                                              # return full title

  insertArguments: (signature, el) ->
    argsEl = $('.arguments', el)                          # cache args list element
    args   = signature.argument                           # should be in a array
    args   = [args] unless $.isArray(args)                # but single arguments are in objects, make array

    for arg in args                                       # for every argument
      if arg and arg.name
        argsEl.append $(templates.argumentsItem(arg))     # build and append element from template

  insertExamples: (examples, el) ->
    examples   = [examples] unless $.isArray(examples)
    examplesEl = $('.examples', el)

    for example in examples
      if example
        exEl = $ templates.examplesItem(example)

        $('.html pre', exEl).text(example.html)
        exEl.appendTo examplesEl

        $('.html', exEl).remove() unless example.html
        $('.css', exEl).remove() unless example.css

        unless example.code
          $('.js', exEl).remove()
          $('.sandbox', exEl).remove()

  highlightCode: ->
    for el in $('pre', @el)
      el   = $(el)                                        # turn back element to jQuery object
      lang = el.data('lang') || 'javascript'              # set language to highlight, defaults to javascript

      el.text $.trim(el.text())                           # trim leading and trailing \n AND remove <!CDATA
      el.snippet lang, { showNum: true, menu: false }     # highlight the code for specific language

    @adjustCodeHeight()                                   # set equal heights for the code boxes

  adjustCodeHeight: ->
    # todo: only equal height for neighbors
    for el in $('.examples .example', @el)
      el        = $(el)
      maxHeight = 0
      codeEls   = $('.code', el)
      sandboxEl = $('.sandbox', el)

      for codeEl in codeEls
        height    = $(codeEl).height()
        maxHeight = height if height > maxHeight
      
      codeEls.height maxHeight
      #$('pre', codeEls).height maxHeight
      sandboxEl.height maxHeight

      if codeEls.length <= 2
        sandboxEl.css({ width: '100%', height: '80px' })

      if codeEls.length is 1
        codeEls.width '100%'
        sandboxEl.remove()

  fixLinks: ->
    for el in $('a', @el)
      el   = $(el)
      href = el.attr('href')
      
      if href.substr(href.length - 1, 1) is '/'
        href = href.substr(0, href.length - 1)

      if href.substr(0, 1) is '/'
        href = href.substr(1, href.length)
      else if href.substr(0, 12) is 'http://api.j'
        href = href.substr(22, href.length)

        el.attr 'href', "#p=#{href}"