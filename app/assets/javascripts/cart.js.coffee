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
    initial_item_price = $cart_item_price.data().initialPrice
    old_item_price = $cart_item_price.data().price
    new_item_price = initial_item_price * quantity

    @_setPrice($cart_item_price, Math.round(+new_item_price))

    new_item_price - old_item_price

  _updateTotalPrice: (difference) ->
    old_total_price = @$total_price.data().price
    new_total_price = old_total_price + difference

    @_setPrice(@$total_price, Math.round(+new_total_price))

  _setPrice: ($element, value) ->
    $element.data('price', value)
    $element.text(value)



window.Cart = Cart
