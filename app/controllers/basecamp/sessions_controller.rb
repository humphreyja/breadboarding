class Basecamp::SessionsController < ApplicationController
  include Authenticated
  
  before_action :assign_basecamp_session

  def show;end

  def edit;end
  
  def update
    @basecamp_session.assign_attributes(basecamp_session_params)
    @basecamp_session.user ||= Current.user
    if @basecamp_session.save
      redirect_to basecamp_session_path
    else
      render :edit
    end
  end
  
  
  private
  
  def basecamp_session_params
    params.require(:basecamp_session).permit(
      :account_id,
      :pitch_project_id,
      :pitch_deck_id,
      :pitch_category_id
    )
  end
  
  def assign_basecamp_session
    @basecamp_session = Current.user.domain.basecamp_session
    @basecamp_session ||= Current.user.domain.build_basecamp_session
  end
  
end