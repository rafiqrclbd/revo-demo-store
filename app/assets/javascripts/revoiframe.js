(function(context){

  var iframe;

  function handleMessage (event) {
    var data = event.data.data;
    iframe.style.width = data.width + 'px';
    iframe.style.height = data.height + 'px';
  }

  function onFrameLoaded () {
    var origin = location.protocol + '//' + location.host,
      message = {
        type: 'hello'
      };
    
    context.addEventListener('message', handleMessage);
    iframe.contentWindow.postMessage(message, origin);
  }

  function show (iframeUrl, targetSelector) {
    var target;

    iframe = document.createElement('iframe');

    if (typeof targetSelector === 'string') {
      target = document.querySelector(targetSelector);
    }
    else {
      // TODO: insert script after current script or set default target
      target = null;
    }

    iframe.addEventListener('load', onFrameLoaded);

    iframe.src = iframeUrl;
    iframe.setAttribute('scrolling', 'no');
    iframe.style.display = 'block';
    target.appendChild(iframe);
  }

  function Form () {}

  Form.prototype = {
    show: show
  }

  context.REVO = context.REVO || {};
  context.REVO.Form = new Form();

})(this);