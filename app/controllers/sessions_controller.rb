class SessionsController < ApplicationController
  include AuthenticationManagement
  before_action :authenticate_user!, only: [:delete]
  
  layout 'public'

  def new
    @session = User::Session.new
  end
  
  def create
    @session = User::Session.new(email: session_params[:email], password: session_params[:password])
    if !@session.locked? && user = @session.authenticate
      sign_in(user)
      if user.accepted_privacy_policy?
        redirect_to authenticated_root_path, notice: 'Welcome back'
      else
        redirect_to sign_ups_user_rights_path(task: :sign_in)
      end
    else
      status = :bad_request
      if @session.locked?
        @session.errors.add(:email, :locked)
        status = :locked
      else
        @session.increment_failed_attempts!
        if @session.too_many_failed_attempts?
          @session.errors.add(:email, :too_many)
          status = :locked
        else
          @session.errors.add(:email_or_password, 'is incorrect')
        end
      end
      render :new, status: status
    end
  end
  
  def destroy
    sign_out_current_user
    
    redirect_to root_path, notice: 'You have been signed out', status: :see_other
  end
  
  private
    def session_params
      params.require(:user_session).permit(:email, :password)
    end
end
