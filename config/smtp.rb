# Default SMTP settings to be used by the Heroku add-on `sendgrid:starter`.
# The SendGrid Starter add-on has a quota of 12,000 emails per month (2016-01-23)
SMTP_SETTINGS = {
  address:              "smtp.sendgrid.net",
  authentication:       :plain,
  enable_starttls_auto: true,
  password:             ENV["SENDGRID_PASSWORD"],
  port:                 587,
  user_name:            ENV["SENDGRID_USERNAME"],
  domain:               ENV["SENDGRID_DOMAIN"]
}.freeze
