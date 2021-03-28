class User::Session
  include ActiveModel::Model
  attr_accessor :email, :password
  
  def initialize(email: nil, password: nil)
    @email = email
    @password = password
  end
  
  def authenticate
    return false unless user = User.find_by(email: @email)
    return false unless authenticated_user = user.authenticate(@password)
    
    authenticated_user
  rescue BCrypt::Errors::InvalidHash
    false
  end
  
  def locked?
    user = User.find_by(email: @email)
    if user && user.locked_at && user.locked_at.after?(Time.now.utc - locked_time)
      true
    else
      false
    end
  end
  
  def locked_time
    if user = User.find_by(email: @email)
      if user.failed_attempts < 10
        1.minute
      elsif user.failed_attempts < 20
        5.minutes
      else
        10.minutes
      end
    else
      0
    end
  end
  
  def increment_failed_attempts!
    if user = User.find_by(email: @email)
      user.increment!(:failed_attempts)

      if too_many_failed_attempts?
        user.locked_at = Time.zone.now
        user.save
      end
    end
  end
  
  def too_many_failed_attempts?
    if user = User.find_by(email: @email)
      user.failed_attempts > 5
    else
      false
    end
  end
end