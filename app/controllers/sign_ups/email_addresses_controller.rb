class SignUps::EmailAddressesController < ApplicationController  
  layout 'public'

  def new
    @registration = User::Registration.new
  end
  
  def create
    @registration = User::Registration.new(email: registration_params[:email])
    
    if @registration.email_address_valid?
      session[:sign_up_email] = @registration.email
      redirect_to new_sign_ups_password_path
    else
      render :new
    end
  end
  
  private
    def registration_params
      params.require(:user_registration).permit(:email)
    end
end
