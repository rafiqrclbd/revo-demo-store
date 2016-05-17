//= require jquery
//= require jquery.selectric.min
//= require jquery.maskedinput

$(function () {
  $('select').selectric({
    disableOnMobile: false
  });

  $('input[data-mask]').each(function () {
    var $item = $(this),
      mask = $item.data('mask') + '',
      placeholder = $item.data('placeholder');

    $item.mask(mask, { placeholder: placeholder });
  });

  $('.selectric-wrapper_suggest').each(function () {
    var $wrapper = $(this),
      $input = $wrapper.find('input'),
      $suggests = $wrapper.find('li');

    $input.on('keyup', function () {
      var value = $input.val();

      if (value && value.length > 2) {
        $wrapper.addClass('selectric-open');
      }
      else {
        $wrapper.removeClass('selectric-open');
      }
    }).on('blur', function () {
      setTimeout(function () {
        $wrapper.removeClass('selectric-open');
      }, 150);
    });

    $suggests.on('click', function () {
      var $suggest = $(this),
        value = $suggest.data('value') || $suggest.text();
      
      $wrapper.removeClass('selectric-open');
      $input.val(value);
    });
  });

  $('.relative').each(function () {
    var $wrapper = $(this),
      $input = $wrapper.find('input[type="text"], textarea, select'),
      placeholder,
      $placeholder,
      withValue = 'with-value';

    if ($input.length) {
      placeholder = $input.attr('placeholder') || $wrapper.find('.selectric .label').text();
      $placeholder = $('<div/>').addClass('placeholder').text(placeholder);
      $wrapper.append($placeholder);
      $input.on('keyup paste change blur', function () {
        var value = $input.val();

        if (value) {
          $wrapper.addClass(withValue);
          $placeholder.animate({
            opacity: 1
          }, 250);
        }
        else {
          $wrapper.removeClass(withValue);
          $placeholder.css({
            opacity: 0
          });
        }
      });
    }
  });

  (function () {
    var origin,
      source,
      message = {
        type: 'resize',
        data: {}
      },
      body, html;

    function init (event) {
      origin = event.origin || event.originalEvent.origin;
      source = event.source;
      window.removeEventListener('message', init);
      window.addEventListener('resize', onResize);
      onResize();
    }

    function onResize () {
      body = document.body;
      html = document.documentElement;
      message.data.width = Math.max(body.offsetWidth, html.scrollWidth, html.offsetWidth);
      message.data.height = Math.max(body.offsetHeight, html.scrollHeight, html.offsetHeight);
      source.postMessage(JSON.stringify(message), origin);
    }

    function onClose () {
      var message = { type: 'close' };
      source.postMessage(JSON.stringify(message), origin);
    }

    $('.header_button').on('click', onClose);

    window.addEventListener('message', init);
  })();
});