class Identities::WelcomeMailer < ApplicationMailer


  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.identities.welcome_mailer.welcome_notification.subject
  #
  def welcome_notification
    @user = params[:user]
    
    mail to: @user.email
  end
end
