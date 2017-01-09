module Locale
  extend ActiveSupport::Concern

  private

  def add_locale_param(url)
    url + "?locale=#{I18n.locale}"
  end

  def subdomain_secrets
    OpenStruct.new(Rails.application.secrets.public_send(I18n.locale))
  end

end
