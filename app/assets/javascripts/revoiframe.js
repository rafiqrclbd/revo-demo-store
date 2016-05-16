(function(context){

  var iframe,
    iframeUrl,
    defaultTargetSelector = '.revo-form',
    onCloseHandler,
    onLoadHandler;

  function handleMessage (event) {
    var eventData = JSON.parse(event.data),
      type = eventData.type,
      data = eventData.data;
    
    if (type === 'resize' && data) {
      iframe.style.width = data.width + 'px';
      iframe.style.height = data.height + 'px';
    }
    else if (type === 'close') {
      if (onCloseHandler && typeof onCloseHandler !== 'function') {
        throw 'onClose handler must be a function';
      }
      onCloseHandler();
    }
  }

  function onFrameLoaded () {
    var origin = iframeUrl.match(/(\w+\:)\/\/[^/]+/),
      message = {
        type: 'hello'
      };

    if (typeof onLoadHandler === 'function') {
      onLoadHandler();
    }
    
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

    if (iframe && iframe.parentNode) {
      iframe.parentNode.removeChild(iframe);
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

  function setOnCloseHandler (handler) {
    onCloseHandler = handler;
  }

  function setOnLoadHandler (handler) {
    onLoadHandler = handler;
  }

  function Form () {}

  Form.prototype = {
    show: show,
    onClose: setOnCloseHandler,
    onLoad: setOnLoadHandler
  }

  context.REVO = context.REVO || {};
  context.REVO.Form = new Form();

})(this);