module ApplicationHelper

   def javascripts
    javascripts = ['jquery', 'rails', 'jquery.autocomplete', 'prettify', 'wmd', 'application']
#    if Rails.env == 'production'
#      javascripts << 'google_analytics'
#    end
#    if Rails.env == 'development'
#      javascripts << ['showdown', 'wmd-base', 'wmd-plus']
#    end
    javascripts << 'uservoice'
  end
  
end
