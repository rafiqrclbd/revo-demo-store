(function(context){

  var iframe,
    iframeUrl,
    defaultTargetSelector = '.revo-form';

  function handleMessage (event) {
    var eventData = JSON.parse(event.data),
      data = eventData.data;
    
    if (data) {
      iframe.style.width = data.width + 'px';
      iframe.style.height = data.height + 'px';
    }
  }

  function onFrameLoaded () {
    var origin = iframeUrl.match(/(\w+\:)\/\/[^/]+/),
      message = {
        type: 'hello'
      };
    
    if (!origin && !origin[0]) {
      return;
    }

    context.addEventListener('message', handleMessage);
    iframe.contentWindow.postMessage(message, origin[0]);
  }

  function show (url, targetSelector) {
    var target;

    if (typeof url !== 'string') {
      throw 'Url must be specified';
    }

    iframe = document.createElement('iframe');
    iframeUrl = url;
    targetSelector = targetSelector || defaultTargetSelector;

    target = document.querySelector(targetSelector);
    
    if (!target) {
      throw 'Error: element ' + targetSelector + ' is not found';
    }

    iframe.addEventListener('load', onFrameLoaded);

    iframe.src = iframeUrl;
    iframe.setAttribute('scrolling', 'no');
    iframe.style.display = 'block';
    iframe.style.width = '100%';
    target.appendChild(iframe);
  }

  function Form () {}

  Form.prototype = {
    show: show
  }

  context.REVO = context.REVO || {};
  context.REVO.Form = new Form();

})(this);