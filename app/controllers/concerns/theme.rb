module Theme

  def theme_url
    "#{Rails.configuration.office_url}/themes/#{Organization.name}"
  end

end
