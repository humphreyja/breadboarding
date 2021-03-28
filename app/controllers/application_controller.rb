class ApplicationController < ActionController::Base
  include AuthenticationManagement
  layout 'application'
  append_before_action :assign_user_from_session
  
  def authenticated_root_path
    breadboards_path
  end
  helper_method :authenticated_root_path
  
  def current_user
    Current.user
  end
  helper_method :current_user

  protected

  def user_account
    @user_account
  end

  private

  def set_user_account
    return unless current_user
    assign_user_account

    if @user_account.nil?
      redirect_to user_accounts_path, alert: 'Please create an account' and return
    end
  end
end
