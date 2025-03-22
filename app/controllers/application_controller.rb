class ApplicationController < ActionController::Base
    def user_is_admin?
        RoleDescription.find(User.find(session[:user_id]).role_description_id).name == "admin"
    end

    helper_method :user_is_admin? 
end
