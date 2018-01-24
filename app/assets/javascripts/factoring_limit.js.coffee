class RevoFactoringLimit
  constructor: ->
    @btn = $('#panel-limit a')
    @bind_click()

  bind_click: ->
    $(document).on 'click', '#panel-factoring-limit a', (e)=>
      e.preventDefault()
      $.get('/factoring/limit').success (data)=>
        @openPopup data.url

  openPopup: (url)->
    $('#revo-iframe').html('')
    REVO.Form.show url, '#revo-iframe'
    REVO.Form.onClose ->
      $('#revoModal').modal('hide')

window.RevoFactoringLimit = RevoFactoringLimit
