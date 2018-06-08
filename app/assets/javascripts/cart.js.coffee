class Cart
  constructor: ->
    @$total_price = $('.total-price')
    @$cart_item_quantity_inputs = $('.cart-item-quantity')

    @listenEvents()

  listenEvents: ->
    self = @

    @$cart_item_quantity_inputs.on 'input', ->
      $tr = $(this).closest('tr')
      $cart_item_price = $tr.find('.cart-item-price')
      quantity = $(this).val()

      self._sendQuantity($tr[0].id, quantity)
      difference = self._updatePrices($cart_item_price, quantity)
      self._updateTotalPrice(difference)

  _sendQuantity: (id, quantity) ->
    $.post("/cart/update_quantity/" + id, { quantity })

  _updatePrices: ($cart_item_price, quantity) ->
    old_item_price = $cart_item_price.data().price
    new_item_price = old_item_price * quantity

    $cart_item_price.text(new_item_price)

    new_item_price - old_item_price

  _updateTotalPrice: (difference) ->
    old_total_price = @$total_price.data().price
    @$total_price.text(old_total_price + difference)



$ ->
  if window.location.pathname == '/cart' then new Cart()
