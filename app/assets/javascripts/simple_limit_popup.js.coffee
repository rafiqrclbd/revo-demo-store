class RevoSimpleLimitPopup
  selector = '#panel-simple-limit-popup a'
  constructor: (simple_limit_url)->
    @simple_limit_url = simple_limit_url
    @bind_click()

  bind_click: ->
    $(document).on 'click', selector, (e)=>
      e.preventDefault()
      @openPopup()

  openPopup: ->
    REVO.Form.showPopup @simple_limit_url
    REVO.Form.onClose ->
      $('#simple-limit-popup').remove()

window.RevoSimpleLimitPopup = RevoSimpleLimitPopup
