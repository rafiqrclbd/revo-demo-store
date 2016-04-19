(function(context){

    var iframe,
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
        targetSelector = targetSelector || defaultTargetSelector;

        target = document.querySelector(targetSelector);

        if (!target) {
            throw 'Error: element ' + targetSelector + ' is not found';
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