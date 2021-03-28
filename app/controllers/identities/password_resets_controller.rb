class Identities::PasswordResetsController < ApplicationController  
  layout 'public'

  def new;end # User forgot password
  
  def create # create reset request
    if user = User.find_by(email: reset_request_params[:email].to_s.strip)
      user.send_request_for_password_reset!
    end
    
    redirect_to identities_password_reset_path
  end
  
  def show;end # reset request sent
  
  def edit # user clicked reset link in email
    @token = params[:token]
    if @token && @user = User.where('reset_password_sent_at > ?', Time.zone.now - 1.day).find_by(reset_password_token: @token)
      render :edit
    else
      redirect_to new_identities_password_reset_path, alert: 'That link is expired, please submit another request to reset your password.'
    end
  end
  
  def update # user updates their password
    @token = reset_params[:token]
    if @token && @user = User.where('reset_password_sent_at > ?', Time.zone.now - 1.day).find_by(reset_password_token: @token)
      @user.password = reset_params[:password]
      @user.password_confirmation = reset_params[:password_confirmation]
      @user.reset_password_sent_at = nil
      @user.reset_password_token = nil
      @user.validate_password_length
      
      if @user.save
        sign_in(@user)
        Identities::PasswordManagementMailer.with(email: @user.email).password_was_changed_notice.deliver_later
        if @user.accepted_privacy_policy?
          redirect_to complete_identities_password_reset_path
        else
          redirect_to sign_ups_user_rights_path(task: :password_reset)
        end
      else
        render :edit, status: :bad_request
      end
    else
      redirect_to new_identities_password_reset_path, alert: 'That link is expired, please submit another request to reset your password.'
    end
  end
  
  private
    def reset_request_params
      params.require(:reset_request).permit(:email)
    end
    
    def reset_params
      params.require(:user).permit(:token, :password, :password_confirmation)
    end
end
