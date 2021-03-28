class User::Registration
  include ActiveModel::Model
  attr_reader :email, :password, :password_confirmation
  
  def initialize(email:nil, password: nil, password_confirmation: nil)
    @email = email
    @password = password
    @password_confirmation = password_confirmation
  end

  def email_address_valid?
    validate_presence_of(:email)
    validate_format_of(:email, /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
    validate_email_domain
    validate_unique_email
    
    errors.count.zero?
  end
  
  def password_valid?
    validate_presence_of(:password)
    validate_length_of(:password, 6)
    validate_passwords_match

    errors.count.zero?
  end
  
  def create_user_and_welcome!
    user = User.new(email: @email, password: @password, password_confirmation: @password_confirmation)
    domain = Domain.find_by(name: @email.split("@").last.downcase)
    user.domain_admin = true if domain.users.count.zero?
    user.domain = domain
    if user.save
      Identities::WelcomeMailer.with(user: user).welcome_notification.deliver_later
      user
    else
      nil
    end
  end
  
  private
  
    def validate_email_domain
      return true if Domain.where(name: @email.split("@").last).exists?
      
      errors.add(:domain, 'is currently not in the system. We are currently not allowing new domains to sign up.')
    end
  
    def validate_presence_of(attribute)
      return true if send(attribute).present?
      
      errors.add(attribute, :blank)
    end
    
    def validate_format_of(attribute, regex)
      return true if send(attribute) =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      
      errors.add(attribute, 'is invalid')
    end
    
    def validate_length_of(attribute, length)
      val = send(attribute)
      if val.respond_to?(:size) && val.size < length
        errors.add(attribute, :too_short)
      end
    end
    
    def validate_passwords_match
      return true if @password == @password_confirmation
      
      errors.add(:passwords, 'do not match')
    end
    
    def validate_unique_email
      return true if User.find_by(email: @email&.strip).nil?
      
      errors.add(:email, :taken)
    end
end