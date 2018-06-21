class RevoRegController < ApplicationController
  include Locale

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

  private

  def render_json(result)
    if result['status'].zero?
      iframe_url = add_locale_param(result['iframe_url'])
      render json: { status: :ok, url: iframe_url }
    else
      render json: { status: result['status'], message: result['message'] }
    end
  end
end
