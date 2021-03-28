module User::TokenIdentifiable
  def generate_token_for(attribute)
    loop do
      token = Digest::SHA1.hexdigest([Time.now.utc, rand].join) # By including the current time we can ensure tokens dont get reused
      break token unless User.where(attribute => token).exists?
    end
  end
end