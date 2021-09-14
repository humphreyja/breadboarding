class Basecamp::AuthorizationCallbacksController < ApplicationController
  include Authenticated

  def edit
    @session = Current.user.domain.basecamp_session
    @session ||= Current.user.domain.build_basecamp_session
    @session.fetch_access_token!(params[:code])
    redirect_to basecamp_session_path
  end
end