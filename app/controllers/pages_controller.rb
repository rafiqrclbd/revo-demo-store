class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'form'

  def index
    if params[:name] == 'v2'
      render params[:name], layout: 'v2'
    else
      render params[:name]
    end
  end
end