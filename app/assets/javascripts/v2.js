//= require jquery
//= require jquery.selectric
//= require jquery.maskedinput

$(function () {
  $('select').selectric();

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
});