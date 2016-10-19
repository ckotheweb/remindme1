class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
    #Strictly after login check if user has a profile, and if not - redirect to new profile creation page.
    def after_sign_in_path_for(resource)
        "/checkprofile"
    end
end
