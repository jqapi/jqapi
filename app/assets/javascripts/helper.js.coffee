class jqapi.Helper
  isMobile: ->
    ua = navigator.userAgent
    
    ua.match(/Android|webOS|iPhone|iPod|BlackBerry|iPad|IEMobile/i)