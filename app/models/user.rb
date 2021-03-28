class User < ApplicationRecord
  include Authenticateable, Regionable, TokenIdentifiable
  belongs_to :domain
  has_many :breadboards
  
  def name
    email.split('@').first.titleize
  end
end
