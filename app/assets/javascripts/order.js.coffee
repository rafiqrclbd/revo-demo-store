class RevoLoan
  constructor: (@order_id)->
    @init_order()
    @init_full_order()
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

  check: ->
    $.get('/revo/'+@order_id).success (data)=>
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
    $.get('/fullrevo/'+@order_id).success (data)=>
      @full_progress.hide()
      if data.status == 'ok'
        @full_btn.show()
        @full_btn.click =>
          @openPopup data.url
      else
        @full_error.show()

  openPopup: (url)->
    REVO.Form.show url, '#revo-iframe'
    REVO.Form.onClose ->
      $('#revoModal').modal('hide') 
    #Use git history to find old method



window.RevoLoan = RevoLoan
