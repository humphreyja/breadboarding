class SignUps::PasswordsController < ApplicationController
  layout 'public'

  def new
    if session[:sign_up_email].nil?
      redirect_to new_sign_ups_email_address_path, alert: 'Please provide an email address to sign up with'
    else
      @registration = User::Registration.new(email: session[:sign_up_email])
    end
  end
  
  def create
    @registration = User::Registration.new(email: session[:sign_up_email], password: registration_params[:password], password_confirmation: registration_params[:password_confirmation])
    
    if @registration.email_address_valid?
      if @registration.password_valid?
        if user = @registration.create_user_and_welcome!
          sign_in(user)
          redirect_to sign_ups_user_rights_path
        else
          redirect_to new_sign_ups_email_address_path, alert: 'We encountered an error creating your account'
        end
      else
        render :new
      end
    else
      redirect_to new_sign_ups_email_address_path, alert: 'Please provide a valid email address to sign up with'
    end
  end
  
  private
    def registration_params
      params.require(:user_registration).permit(:password, :password_confirmation)
    end
end
