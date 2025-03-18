class UsersController < ApplicationController

  layout :choose_layout
  

  def login 
  end

  def logout
  end

  def dashboard
  end

  private 

  def choose_layout
    case action_name
    when "dashboard"
      "home_layout"
    when "login"
      "authentication_layout"
    end
  end

end

