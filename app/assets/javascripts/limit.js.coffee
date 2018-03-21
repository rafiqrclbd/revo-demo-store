class RevoLimit
  constructor: ->
    @listenEvents()

  listenEvents: ->
    $(document).on 'click', '#panel-limit a', @initPopup

  initPopup: (e) =>
    e.preventDefault()
    $.get('/revo/limit').success (data)=>
      @openPopup data.url

  openPopup: (url)->
    REVO.Form.showPopup(url)

window.RevoLimit = RevoLimit
