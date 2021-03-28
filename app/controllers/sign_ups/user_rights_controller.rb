class SignUps::UserRightsController < ApplicationController
  layout 'public'

  def show
    @user = Current.user || User.new
    @task = params[:task] || 'sign_up'
  end
  
  def update
    @user = Current.user
    @user&.accept_privacy_policy!
    if params.dig(:user, :task) == 'password_reset'
      redirect_to complete_identities_password_reset_path
    elsif params.dig(:user, :task) == 'verify_email_address'
      redirect_to complete_identities_verify_email_address_path
    elsif params.dig(:user, :task) == 'sign_in'
      redirect_to authenticated_root_path
    else
      redirect_to complete_sign_up_path
    end
  end
end
