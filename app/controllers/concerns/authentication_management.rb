module AuthenticationManagement
  NONACTIVE_USER_SESSIONS_EXPIRE_AFTER = 2.weeks.freeze
  
  # Check the session for a valid user session. Will redirect to sign in if failed
  def authenticate_user!
    return true if assign_user_from_session && current_user_can_be_signed_in?

    redirect_to sign_in_path
  end

  # Creates a new session for the user (does NOT authenticate)
  def sign_in(user)
    reset_session
    user.did_sign_in!(ip_address: request.remote_ip)
    session[:user_id] = user.id
    Current.user = user
    refresh_user_session_validity_expiration
  end
  
  # Deletes the session and empties the current user object
  def sign_out_current_user
    Current.user = nil
    reset_session
  end
  
  # Refreshes the active time period of the users session
  def refresh_user_session_validity_expiration
    session[:user_signed_in_at] = Time.now.utc.to_i
    session[:sign_in_validity_token] = Current.user.password_session_value
  end
  
  # Checks if the active period of the users session is older than NONACTIVE_USER_SESSIONS_EXPIRE_AFTER
  def user_session_validity_expired?
    return false unless session[:user_signed_in_at].is_a?(Integer)

    session[:user_signed_in_at] < (Time.now.utc - NONACTIVE_USER_SESSIONS_EXPIRE_AFTER).to_i
  end
  
  def valid_session_credentials?(user)
    session[:sign_in_validity_token] == user.password_session_value
  end
  
  # Assigns the current user object if it exists. If one exists but it is expired, it will be removed
  def assign_user_from_session
    return Current.user if Current.user # this request as already been checked
    
    sign_out_current_user if user_session_validity_expired?
    return false if session[:user_id].nil?
    
    authenticated_user = User.find_by(id: session[:user_id])
    if authenticated_user &&  valid_session_credentials?(authenticated_user)
      Current.user = authenticated_user
      refresh_user_session_validity_expiration
    else
      false
    end
  end
  
  # Checks if the current user can actually be signed in.
  #  If the account is locked, or the user is not fully registered we don't let them sign in.
  def current_user_can_be_signed_in?
    return false unless Current.user.registered?
    return false if Current.user.locked?
    
    true
  end  
end
