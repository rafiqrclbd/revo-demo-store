//= require jquery
//= require jquery.selectric
//= require jquery-ui
//= require jquery.maskedinput

$(function(){
  $('.input__text-datepicker').datepicker($.extend($.datepicker.regional['ru'], {
    changeMonth: true,
    changeYear: true,
    showOtherMonths: true,
    dateFormat: "dd/mm/yy",
    maxDate: new Date(),
    yearRange: "1900:" + (new Date()).getFullYear()
  }));

  $('.input__dropdown, .ui-datepicker-month, .ui-datepicker-year').selectric({
    arrowButtonMarkup: '<b class="selectric-button">&#x25be;</b>'
  });

  $('input[data-mask]').each(function(){
    var $item = $(this),
      mask = $item.data('mask') + '',
      placeholder = $item.data('placeholder');

    $item.mask(mask, { placeholder: placeholder });
  });
});