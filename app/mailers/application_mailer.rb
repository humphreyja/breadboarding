class ApplicationMailer < ActionMailer::Base
  helper :application

  default from: 'jacob@humphreyconsulting.com'
  layout 'mailer'
end
