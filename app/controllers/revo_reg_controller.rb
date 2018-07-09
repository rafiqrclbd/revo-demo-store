class RevoRegController < ApplicationController
  def iframe_v1
    result = Reg::IframeV1Service.new(current_user).call
    render_json(result)
  end

  def iframe_v2
    result = Reg::IframeV2Service.new(current_user).call
    render_json(result)
  end

  def factoring_v1
    result = Reg::FactoringV1Service.new(current_user).call
    render_json(result)
  end

  def callback
    order_id = params[:order_id].split('-').last
    order = Order.find_by(uid: order_id)
    order.update!(revo_status: params[:decision], revo_amount: params[:amount])
    render text: :ok
  rescue
    render text: :fail
  end
end
