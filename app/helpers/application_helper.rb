module ApplicationHelper
  def locale_logo(current_locale)
    case current_locale
    when :en
      image_tag('revo-logo-eng.svg', class: 'logo-eng')
    else
      image_tag('revo-logo-ru.png', class: 'logo-ru')
    end
  end

  def revo_status_locale(status)
    status ? t(".#{status}") : ''
  end
end
