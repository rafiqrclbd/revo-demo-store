class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'form'

  def index
    render params[:name]
  end
end