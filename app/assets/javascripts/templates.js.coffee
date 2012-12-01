class jqapi.Templates
  subcatsList: ->
    '<ul class="sub-cats" />'

  categoryItem: (pos, name) ->
    """
    <li class='#{pos}-cat'>
      <span class='#{pos}-cat-name'>#{name}</span>
    </li>
    """

  entriesList: ->
    '<ul class="entries" />'

  entriesItem: (entry) ->
    """
    <li class='entry' data-slug='#{entry.slug}'>
      <span class='title'>#{entry.title}</span>
      <span class='desc'>#{entry.desc}</span>
    </li>
    """

  content: (entry) ->
    """
    <h1>#{entry.title}</h1>
    <p>#{entry.desc}</p>
    <p>#{entry.entries.length} entries</p>
    """

  resultsList: ->
    '<ul id="results" class="entries" />'