class RevoOrderController < ApplicationController
  def iframe_v1
    result = Order::IframeV1Service.new(current_user, params[:id]).call
    render_json(result)
  end

  def factoring_precheck_v1
    result = Order::FactoringPrecheckV1Service.new(current_user, params[:id], type: params[:type], amount: params[:amount]).call
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
    result = Order::OnlineV2Service.new(current_user, params[:id]).call
    render_json(result)
  end

  def status
    result = Order::StatusService.new(current_user, params[:id]).call
    render_json(result)
  end
end
