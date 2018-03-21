class RevoLimit
  constructor: ->
    @listenEvents()

  listenEvents: ->
    $(document).on 'click', '.revo-popup', @initPopup

  initPopup: (e) =>
    e.preventDefault()
    url = $(e.target).data('url')
    $.get(url).success (data)=>
      @openPopup data.url

  openPopup: (url)->
    REVO.Form.showPopup(url)



$ ->
  new RevoLimit()
