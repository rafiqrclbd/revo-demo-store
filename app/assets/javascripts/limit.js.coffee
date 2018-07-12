class RevoLimit
  constructor: ->
    @listenEvents()

  listenEvents: ->
    $(document).on 'click', '.revo-popup', @initPopup

  initPopup: (e) =>
    e.preventDefault()
    url = $(e.target).data('url')
    $.get(url).success (data)=>
      if data.url
        @openPopup data.url
      else
        alert(JSON.stringify(data, null, 4))

  openPopup: (url)->
    REVO.Form.showPopup(url)

$ ->
  new RevoLimit()
