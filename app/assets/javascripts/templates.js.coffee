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
        <a href='http://api.jquery.com/#{entry.slug}'>Original: api.jquery.com/#{entry.slug}</a>
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
    def = ""
    argt = []

    if arg.default?
      def = "( default: <code>#{arg.default}</code> )"

    if $.isArray arg.type
      for a in arg.type        
        argt.push a.name
    else
      argt = [arg.type]

    argt = argt.join ", "

    """
    <tr>
      <td class='name'>#{arg.name} #{def}</td>
      <td class='type'>#{argt}</td>
      <td class='desc'>#{arg.desc}</td>
    </tr>
    """

  propertyItem: (prop) ->
    def = ""
    added = "" 
    types = []
    args = []
    ret = ""

    if prop.default? 
      def = "(default: <code>#{prop.default}</code>)"

    if prop.added? 
      added = """
        <strong>
         ( version added: 
          <a href="//api.jquery.com/category/version/#{prop.added}/">#{prop.added}</a> )
        </strong>
      """

    if $.isArray prop.type
      for t in prop.type        
        types.push t.name
    else
      types = [prop.type]

    types = $.map types , (t) ->
      "<a href='//api.jquery.com/Types##{t}'>#{t}</a>"

    types = types.join ', '

    if prop.argument?
      for a in prop.argument                
        args.push "<a href='//api.jquery.com/Types##{a.type}'>#{a.type}</a> #{a.name}"
      args = "( #{args.join ', '} )"
    else 
      args = ""

    if prop.return?
      ret = " => <a href='//api.jquery.com/Types##{prop.return.type}'>#{prop.return.type}</a>"
      
    """
    <tr class="property"><td colspan=3>
      <div>
        <strong>#{prop.name}</strong>
        #{def}
      </div>
      <div>
        Type: #{types} #{args}#{ret}
      </div>
      <div class="desc">#{prop.desc} #{added}</div>      

    </td></tr>   
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