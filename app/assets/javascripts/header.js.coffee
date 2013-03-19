class jqapi.Header
  constructor: ->
    @el           = $ '#header'                           # parent element
    @signaturesEl = $('#signatures-nav', @el)             # signatures navigation list
    self          = @

    jqapi.events.on 'entry:done', (e, entry) =>           # when there is a new entry loaded
      @updateSignatureNav entry                           # update the header signatures navigation

    @el.on 'click', '#signatures-nav a', ->               # it's the o again
      sigText  = $.trim($(@).text())                      # hacked together, use events instead
      entryEl  = $('#entry')
      targetEl = $(".signature .title:contains(#{sigText})", entryEl)
      
      if targetEl.length
        entryEl.scrollTop 0
        entryEl.scrollTop targetEl.parent().offset().top - self.el.height()

      false

    @el.height $('#search').height()                      # set the same height as the search box has

  updateSignatureNav: (entry) ->
    signatures = @getSignatures(entry)                    # get a array of all signature aguments

    @signaturesEl.empty()                                 # empty the current list

    for sig in signatures
      tmpl = templates.signatureNavItem(entry.title, sig) # build list item from template

      @signaturesEl.append tmpl                           # and append it to list el

  getSignatures: (entry) ->                               # orange b.
    retArr = []

    for ent in entry.entries
      sigArr = ent.signatures
      sigArr = [ent.signatures] unless $.isArray(sigArr)

      for sig in sigArr
        argsArr = sig.argument
        argsArr = [sig.argument] unless $.isArray(argsArr)
        joinArr = []

        for arg in argsArr
          comma = ""
          comma = ", " unless joinArr.length is 0
          if arg and arg.optional
            joinArr.push "[#{comma}#{arg.name}]" if arg and arg.name
          else
            joinArr.push "#{comma}#{arg.name}" if arg and arg.name

        retArr.push joinArr.join(' ')


    retArr