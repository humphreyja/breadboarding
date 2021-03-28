module User::Authenticateable
  extend ActiveSupport::Concern

  included do
    validates :email, presence: true
    validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create
  
    has_secure_password
  end
  
  def did_sign_in!(ip_address: nil)
    self.increment(:sign_in_count)
    self.failed_attempts = 0
    self.locked_at = nil
    self.last_seen_at = Time.now.utc
    self.last_seen_from_ip_address = ip_address
    save
  end
  
  # This is a hashed and sliced version of the password digest that will
  #  change if the password changes. Allowing sessions to be expired
  def password_session_value
    Digest::SHA1.hexdigest(password_digest.to_s[0..10])
  end
  
  def registered?
    return false if password_digest.nil?
    return false if accepted_privacy_policy_at.nil?
    
    true
  end
  
  def accepted_privacy_policy?
    return false if accepted_privacy_policy_at.nil?
    
    true
  end
  
  def accept_privacy_policy!
    self.accepted_privacy_policy_at = Time.zone.now.utc
    save
  end
  
  def locked?
    return false if locked_at.nil?
    
    true
  end
  
  def validate_password_length
    # TODO: This isn't working
    if password.respond_to?(:size) && password.size < 6
      errors.add(:password, :too_short)
    end
  end
  
  def send_request_for_password_reset!
    self.reset_password_token = generate_token_for(:reset_password_token)
    self.reset_password_sent_at = Time.zone.now.utc
    return false unless save(validate: false)

    Identities::PasswordManagementMailer.with(email: email, token: reset_password_token).reset_password_request.deliver_later
  end
end