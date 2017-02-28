class RevoSimpleLimit
  constructor: (simple_limit_url)->
    @btn = $('#panel-simple-limit a')
    @simple_limit_url = simple_limit_url
    @bind_click()

  bind_click: ->
    $(document).on 'click', '#panel-simple-limit a', (e)=>
      e.preventDefault()
      @openPopup()

  openPopup: ->
    $('#revo-iframe').html('')
    REVO.Form.show @simple_limit_url, '#revo-iframe'
    REVO.Form.onClose ->
      $('#revoModal').modal('hide')

window.RevoSimpleLimit = RevoSimpleLimit
