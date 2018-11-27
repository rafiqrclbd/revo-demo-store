class RevoLoan
  constructor: (@order_id)->
    @init_order()
    @init_full_order_v1()
    @init_full_order_v2()
    @init_payu()
    @init_factoring_order()
    @init_factoring_precheck_order()
    @url = null

  init_order: ->
    @btn = $('.order-loan .loan-btn')
    @error = $('.order-loan .loan-error')
    @progress = $('.order-loan .progress')
    @btn.hide()
    @error.hide()

  init_full_order_v1: ->
    @full_btn_v1 = $('.full-order-loan-v1 .loan-btn')
    @full_error_v1 = $('.full-order-loan-v1 .loan-error')
    @full_progress_v1 = $('.full-order-loan-v1 .progress')
    @full_btn_v1.hide()
    @full_error_v1.hide()

  init_full_order_v2: ->
    @full_btn_v2 = $('.full-order-loan-v2 .loan-btn')
    @full_error_v2 = $('.full-order-loan-v2 .loan-error')
    @full_progress_v2 = $('.full-order-loan-v2 .progress')
    @full_btn_v2.hide()
    @full_error_v2.hide()

  init_factoring_order: ->
    @factoring_btn = $('.factoring-order-loan .loan-btn')
    @factoring_error = $('.factoring-order-loan .loan-error')
    @factoring_progress = $('.factoring-order-loan .progress')
    @factoring_btn.hide()
    @factoring_error.hide()

  init_factoring_precheck_order: ->
    @factoring_precheck_btn = $('.factoring-precheck-order-loan .loan-btn')
    @factoring_precheck_finish_btn = $('.factoring-precheck-order-loan .loan-finish-btn')
    @factoring_precheck_cancel_btn = $('.factoring-precheck-order-loan .loan-cancel-btn')
    @factoring_precheck_change_btn = $('.factoring-precheck-order-loan .loan-change-btn')
    @factoring_precheck_status_btn = $('.factoring-precheck-order-loan .loan-status-btn')
    @factoring_precheck_amount_input = @factoring_precheck_change_btn
      .closest('.change-section')
      .find("input[name='amount']")
    @factoring_precheck_error = $('.factoring-precheck-order-loan .loan-error')
    @factoring_precheck_progress = $('.factoring-precheck-order-loan .progress')
    @factoring_precheck_btn.hide()
    @factoring_precheck_finish_btn.hide()
    @factoring_precheck_cancel_btn.hide()
    @factoring_precheck_change_btn.hide()
    @factoring_precheck_status_btn.hide()
    @factoring_precheck_amount_input.hide()
    @factoring_precheck_error.hide()

  init_payu: ->
    $('.payu-btn').on 'click', (e)=>
      term = $(e.currentTarget).data('term')
      @openPopup(location.origin + '/orders/' + @order_id + '/payu?term=' + term, 'https://demo.revoup.ru')

  check: ->
    $.get('/revo_order/iframe_v1?id=' + @order_id).success (data)=>
      @progress.hide()
      console.log(data)
      if data.status == 'ok'
        @btn.show()
        @btn.click =>
          console.log(data.url)
          @openPopup data.url
        @url = data.url
      else
        @error.show()

  full_check_v1: ->
    $.get('/revo_order/online_v1?id=' + @order_id).success (data)=>
      @full_progress_v1.hide()
      if data.status == 'ok'
        @full_btn_v1.show()
        @full_btn_v1.click =>
          @openPopup data.url
      else
        @full_error_v1.show()

  full_check_v2: ->
    $.get('/revo_order/online_v2?id=' + @order_id).success (data)=>
      @full_progress_v2.hide()
      if data.status == 'ok'
        @full_btn_v2.show()
        @full_btn_v2.click =>
          @openPopup data.url
      else
        @full_error_v2.show()

  factoring_check: ->
    $.get('/revo_order/factoring_v1?id=' + @order_id).success (data)=>
      @factoring_progress.hide()
      if data.status == 'ok'
        @factoring_btn.show()
        @factoring_btn.click =>
          @openPopup data.url
      else
        @factoring_error.show()

  factoring_precheck_check: ->
    $.get('/revo_order/factoring_precheck_v1?id=' + @order_id).success (data)=>
      @factoring_precheck_progress.hide()
      if data.status == 'ok'
        @factoring_precheck_btn.show()
        @factoring_precheck_btn.click =>
          @openPopup data.url
      else
        @factoring_precheck_error.show()

      @factoring_precheck_finish_btn.show()
      @factoring_precheck_cancel_btn.show()
      @factoring_precheck_change_btn.show()
      @factoring_precheck_status_btn.show()
      @factoring_precheck_amount_input.show()
      @factoring_precheck_finish_btn.click =>
        @finalizeOrder()
      @factoring_precheck_cancel_btn.click =>
        @cancelOrder()
      @factoring_precheck_change_btn.click =>
        @changeOrder()
      @factoring_precheck_status_btn.click =>
        @statusOrder()

  openPopup: (url, origin)->
    REVO.Form.showPopup(url)
    #Use git history to find old method

  finalizeOrder: ->
    $.get('/revo_order/factoring_precheck_v1?id=' + @order_id + '&type=finish').success (data)=>
      @factoring_precheck_btn.hide()
      @factoring_precheck_progress.hide()
      @factoring_precheck_finish_btn.hide()
      @factoring_precheck_cancel_btn.hide()
      @factoring_precheck_change_btn.hide()
      @factoring_precheck_status_btn.hide()
      @factoring_precheck_amount_input.hide()
      @factoring_precheck_error.show()
      unless data.status == 'ok'
        alert(JSON.stringify(data, null, 4))

  cancelOrder: ->
    $.get('/revo_order/factoring_precheck_v1?id=' + @order_id + '&type=cancel').success (data)=>
      @factoring_precheck_btn.hide()
      @factoring_precheck_progress.hide()
      @factoring_precheck_finish_btn.hide()
      @factoring_precheck_cancel_btn.hide()
      @factoring_precheck_change_btn.hide()
      @factoring_precheck_status_btn.hide()
      @factoring_precheck_amount_input.hide()
      @factoring_precheck_error.show()
      unless data.status == 'ok'
        alert(JSON.stringify(data, null, 4))

  changeOrder: ->
    amount = @factoring_precheck_amount_input.val()
    $.get('/revo_order/factoring_precheck_v1?id=' + @order_id + '&type=change', {amount}).success (data)=>
      @factoring_precheck_btn.hide()
      @factoring_precheck_progress.hide()
      @factoring_precheck_finish_btn.hide()
      @factoring_precheck_cancel_btn.hide()
      @factoring_precheck_change_btn.hide()
      @factoring_precheck_status_btn.hide()
      @factoring_precheck_amount_input.hide()
      @factoring_precheck_error.show()
      unless data.status == 'ok'
        alert(JSON.stringify(data, null, 4))

  statusOrder: ->
    amount = @factoring_precheck_amount_input.val()
    $.get('/revo_order/status?id=' + @order_id, {amount}).success (data)=>
      @factoring_precheck_btn.hide()
      @factoring_precheck_progress.hide()
      @factoring_precheck_finish_btn.hide()
      @factoring_precheck_cancel_btn.hide()
      @factoring_precheck_change_btn.hide()
      @factoring_precheck_status_btn.hide()
      @factoring_precheck_amount_input.hide()
      @factoring_precheck_error.show()
      unless data.status == 'ok'
        alert(JSON.stringify(data, null, 4))

window.RevoLoan = RevoLoan
