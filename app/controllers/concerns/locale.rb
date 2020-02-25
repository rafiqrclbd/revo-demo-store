module Locale
  extend ActiveSupport::Concern

  private

  def add_locale_param(url)
    uri = URI(url)
    uri.query = [uri.query, "locale=#{I18n.locale}"].compact.join('&')
    uri.to_s
  end

  def subdomain_secrets
    OpenStruct.new(Rails.application.secrets.public_send(I18n.locale))
  end
end
