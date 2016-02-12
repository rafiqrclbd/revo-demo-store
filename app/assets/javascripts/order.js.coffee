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
      console.log data
      if data.status == 'ok'
        @btn.show()
        @btn.click =>
          @openPopup data.url
        @url = data.url
      else
        @error.show()

  openPopup: (url)->
    console.log url
    window.open(url, "Revo", "height=500, width=700, top=100, left=200, scrollbars=1")



window.RevoLoan = RevoLoan
