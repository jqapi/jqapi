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

  entry: (entry) ->
    """
    <div id='entry-header'>
      <h1>#{entry.title}</h1>
      <p>#{entry.desc}</p>
      <ul class='categories'>
        <li>manipulation</li>
        <li>love</li>
      </ul>
    </div>
    """

  signatureNavItem: (title, signature) ->
    sigText = title

    if title.substr(title.length - 2) is '()'             # if its a function
      methodName = title.substr(0, title.length - 2)      # cut out the empty ()
      sigText    = "#{methodName}(#{signature})"          # and fill it with arguments

    """
    <li>
      <a href="#"><span>#{sigText}</span></a>
    </li>
    """