class jqapi.Homepage
  constructor: ->
    @showAllDonors()

  showAllDonors: ->
    donorsEl = $('#donors ul')
    allEl    = $('<li class="all"><a href="#all-donors">Show all...</a></li>')

    allEl.appendTo donorsEl

    allEl.one 'click', ->
      $('.donor', donorsEl).show()
      donorsEl.children('li').css 'display', 'inline' # fix so hidden lis are not displayed as blocks
      allEl.remove()

      false