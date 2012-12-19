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
    <div id='entry-wrapper'>
      <div id='entry-header'>
        <h1>#{entry.title}</h1>
        <p>#{entry.desc}</p>
        <ul id='categories'></ul>
      </div>
      <ul id='entries'></ul>
    </div>
    """

  entryEntriesItem: (entry) ->
    """
    <li class='entry'>
      <ul class='signatures'></ul>
      <div class='longdesc'>#{entry.longdesc}</div>
      <ul class='examples clearfix'></ul>
    </li>
    """

  signaturesItem: (title, ret, version) ->
    """
    <li class='signature'>
      <h2>
        <span class='title'>#{title}</span>
        <span class='return'>&rarr; #{ret}</span>
        <span class='version'>#{version}</span>
      </h2>
      <table class='arguments'><tbody></tbody></table>
    </li>
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

  argumentsItem: (arg) ->
    """
    <tr>
      <td class='name'>#{arg.name}</td>
      <td class='type'>#{arg.type}</td>
      <td class='desc'>#{arg.desc}</td>
    </tr>
    """

  examplesItem: (example) ->
    """
    <li class='example clearfix'>
      <div class='desc'><p>#{example.desc}</p></div>
      <div class='row clearfix'>
        <div class='left'>
          <div class='code html'>
            <pre data-lang='html'/>
            <span class='lang'>HTML</span>
          </div>
          <div class='code js'>
            <pre data-lang='javascript'>#{example.code}</pre>
            <span class='lang'>JS</span>
          </div>
        </div>
        <div class='right'>
          <div class='code css'>
            <pre data-lang='css'>#{example.css}</pre>
            <span class='lang'>CSS</span>
          </div>
          <div class='sandbox'>
            <div class='play'>loading demo...</div>
            <span class='lang'>DEMO</span>
          </div>
        </div>
      </div>
    </li>
    """