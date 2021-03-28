class Identities::VerifyEmailAddressesController < ApplicationController  
  layout 'public'
  
  def show # user updates their password
    @token = params[:token]
    if @token && @user = User.find_by(confirmation_token: @token)
      if @user.verify_email_address!
        sign_in(@user)
        if @user.accepted_privacy_policy?
          redirect_to complete_identities_verify_email_address_path
        else
          redirect_to sign_ups_user_rights_path(task: :verify_email_address)
        end
      else
        redirect_to invalid_identities_verify_email_address_path
      end
    else
      redirect_to invalid_identities_verify_email_address_path
    end
  end
end
