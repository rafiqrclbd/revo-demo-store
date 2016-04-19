class RevoLoan
  constructor: (@order_id)->
    @btn = $('.order-loan .loan-btn')
    @error = $('.order-loan .loan-error')
    @progress = $('.order-loan .progress')
    @btn.hide()
    @error.hide()
    @url = null

  check: ->
    $.get('/revo/'+@order_id).success (data)=>
      @progress.hide()
      if data.status == 'ok'
        @btn.show()
        @btn.click =>
          @openPopup data.url
        @url = data.url
      else
        @error.show()

  openPopup: (url)->
    REVO.Form.show url, '#revo-iframe'
    #Use git history to find old method



window.RevoLoan = RevoLoan
