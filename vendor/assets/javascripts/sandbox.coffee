# https://github.com/versal/sandbox-js

window.sandbox = (options = {}) ->
  options = $.extend true, {}, {
    html: '', css: '', js: ''
    external: { js: {}, css: {} }
    dialogs: true
    onLog: (->)
  }, options

  { js, html, css, external } = options

  iframe = $('<iframe seamless sandbox="allow-scripts allow-forms allow-top-navigation allow-same-origin">').appendTo(options.el || 'body')[0]
  doc = iframe.contentDocument || iframe.contentWindow.document

  stopDialogs = "var dialogs = ['alert', 'prompt', 'confirm']; for (var i = 0; i < dialogs.length; i++) window[dialogs[i]] = function() {};"

  scripts = [js]

  unless options.dialogs
    scripts = [stopDialogs].concat scripts

  allScripts = ("(function() { #{script} })();" for script in scripts).join ''
  externalJS = for src in external.js
    "<script src='#{src}'></script>"

  externalCSS = for src in external.css
    "<link rel='stylesheet' type='text/css' href='#{src}' media='screen' />"

  doc.open()
  doc.write """
    #{html}
    #{externalJS.join ''}
    #{externalCSS.join ''}
    <script>#{allScripts}</script>
    <style>#{css}</style>
  """
  doc.close()

  return iframe