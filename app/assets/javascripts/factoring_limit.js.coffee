class RevoFactoringLimit
  constructor: ->
    @listenEvents()

  listenEvents: ->
    $(document).on 'click', '#panel-factoring-limit a', @initPopup

  initPopup: (e) =>
    e.preventDefault()
    $.get('/factoring/limit').success (data)=>
      @openPopup data.url

  openPopup: (url)->
    REVO.Form.showPopup(url)

window.RevoFactoringLimit = RevoFactoringLimit
