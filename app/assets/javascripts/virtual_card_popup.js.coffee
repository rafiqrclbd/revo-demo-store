class RevoVirtualCardPopup
  selector = '#panel-virtual-card a'
  constructor: (virtual_card_url)->
    @virtual_card_url = virtual_card_url
    @bind_click()

  bind_click: ->
    $(document).on 'click', selector, (e)=>
      e.preventDefault()
      @openPopup()

  openPopup: ->
    $('#revo-iframe').html('')  
    REVO.Form.show @virtual_card_url, '#revo-iframe'
    REVO.Form.onClose ->
      $('#revoModal').modal('hide')

window.RevoVirtualCardPopup = RevoVirtualCardPopup
