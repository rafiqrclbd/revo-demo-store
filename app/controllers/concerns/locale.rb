module Locale
  extend ActiveSupport::Concern

  private

  SUBDOMAIN_LOCALES = {
    'engstore' => :en,
    'store'    => :ru
  }

  def subdomain
    request.subdomains.first
  end

  def subdomain_locale
    SUBDOMAIN_LOCALES.fetch(subdomain, I18n.default_locale)
  end

  def add_subdomain_locale_param(url)
    url + "?locale=#{subdomain_locale}"
  end

  def subdomain_secrets
    OpenStruct.new(Rails.application.secrets.public_send(subdomain_locale))
  end

end
