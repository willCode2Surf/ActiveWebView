
var ActiveWebView = {
	
  send: function(method, args) {

	 var payload = JSON.stringify({
     arguments: args || []
    })
  
    var url = 'native://' + method + '/' + encodeURIComponent(message)
      , frame = document.createElement('iframe')

    frame.src = url
    frame.style.display = 'none'
    
    document.body.appendChild(iframe)
    iframe.parentNode.removeChild(iframe)
    
  }

}