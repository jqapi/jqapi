class jqapi.Header
  constructor: ->
    @el           = $ '#header'                           # parent element
    @signaturesEl = $('#signatures-nav', @el)             # signatures navigation list

    jqapi.events.on 'entry:done', (e, entry) =>           # when there is a new entry loaded
      @updateSignatureNav entry                           # update the header signatures navigation

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
        argsStr = ''

        for arg in argsArr
          argsStr += "#{arg.name}, " if arg and arg.name

        retArr.push argsStr.substr(0, argsStr.length - 2)

    retArr