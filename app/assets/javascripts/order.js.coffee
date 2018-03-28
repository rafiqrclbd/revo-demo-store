class RevoLoan
  constructor: (@order_id)->
    @init_order()
    @init_full_order()
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

  init_full_order: ->
    @full_btn = $('.full-order-loan .loan-btn')
    @full_error = $('.full-order-loan .loan-error')
    @full_progress = $('.full-order-loan .progress')
    @full_btn.hide()
    @full_error.hide()

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
    @factoring_precheck_error = $('.factoring-precheck-order-loan .loan-error')
    @factoring_precheck_progress = $('.factoring-precheck-order-loan .progress')
    @factoring_precheck_btn.hide()
    @factoring_precheck_finish_btn.hide()
    @factoring_precheck_cancel_btn.hide()
    @factoring_precheck_error.hide()

  init_payu: ->
    $('.payu-btn').on 'click', (e)=>
      term = $(e.currentTarget).data('term')
      @openPopup(location.origin + '/orders/' + @order_id + '/payu?term=' + term, 'https://demo.revoup.ru')

  check: ->
    $.get('/revo/' + @order_id).success (data)=>
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

  full_check: ->
    $.get('/fullrevo/' + @order_id).success (data)=>
      @full_progress.hide()
      if data.status == 'ok'
        @full_btn.show()
        @full_btn.click =>
          @openPopup data.url
      else
        @full_error.show()

  factoring_check: ->
    $.get('/factoring/' + @order_id).success (data)=>
      @factoring_progress.hide()
      if data.status == 'ok'
        @factoring_btn.show()
        @factoring_btn.click =>
          @openPopup data.url
      else
        @factoring_error.show()

  factoring_precheck_check: ->
    $.get('/factoring_precheck/' + @order_id).success (data)=>
      @factoring_precheck_progress.hide()
      if data.status == 'ok'
        @factoring_precheck_btn.show()
        @factoring_precheck_btn.click =>
          @openPopup data.url
      else
        @factoring_precheck_error.show()

      @factoring_precheck_finish_btn.show()
      @factoring_precheck_cancel_btn.show()
      @factoring_precheck_finish_btn.click =>
        @finalizeOrder()
      @factoring_precheck_cancel_btn.click =>
        @cancelOrder()

  openPopup: (url, origin)->
    REVO.Form.showPopup(url)
    REVO.Form.onClose ->
      window.location.reload()
    #Use git history to find old method

  finalizeOrder: ->
    $.post('/factoring_precheck/' + @order_id + '/finish').success (data)=>
      @factoring_precheck_btn.hide()
      @factoring_precheck_progress.hide()
      @factoring_precheck_finish_btn.hide()
      @factoring_precheck_cancel_btn.hide()
      @factoring_precheck_error.show()

  cancelOrder: ->
    $.post('/factoring_precheck/' + @order_id + '/cancel').success (data)=>
      @factoring_precheck_btn.hide()
      @factoring_precheck_progress.hide()
      @factoring_precheck_finish_btn.hide()
      @factoring_precheck_cancel_btn.hide()
      @factoring_precheck_error.show()

window.RevoLoan = RevoLoan
