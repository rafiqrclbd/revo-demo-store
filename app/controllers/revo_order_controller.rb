class RevoOrderController < ApplicationController
  include Locale

  def iframe_v1
    result = Order::IframeV1Service.new(current_user, params[:id]).call
    render_json(result)
  end

  def factoring_precheck_v1
    result = Order::FactoringPrecheckV1Service.new(current_user, params[:id], params[:type]).call
    render_json(result)
  end

  def factoring_v1
    result = Order::FactoringV1Service.new(current_user, params[:id]).call
    render_json(result)
  end

  def online_v1
    result = Order::OnlineV1Service.new(current_user, params[:id]).call
    render_json(result)
  end

  def online_v2
    # result = Order::OnlineV2Service.new(current_user, params[:id]).call
    # render_json(result)
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
