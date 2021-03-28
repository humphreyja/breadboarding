class SignUpsController < ApplicationController
  layout 'public'
  

  def show
    session[:sign_up_email] = nil
  end

  def complete
    session[:sign_up_email] = nil
  end
end
