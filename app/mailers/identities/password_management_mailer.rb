class Identities::PasswordManagementMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.identities.password_management_mailer.reset_password_request.subject
  #
  def reset_password_request
    @email = params[:email]
    @token = params[:token]
    
    mail to: @email, subject: 'Instructions to reset your password'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.identities.password_management_mailer.password_was_changed_notice.subject
  #
  def password_was_changed_notice
    @email = params[:email]
    @token = params[:token]

    mail to: @email, subject: 'Your password was changed'
  end
end
