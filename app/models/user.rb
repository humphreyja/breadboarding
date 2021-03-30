class User < ApplicationRecord
  include Authenticateable, Regionable, TokenIdentifiable
  belongs_to :domain
  has_many :breadboards
  
  enum theme: [
    :light,
    :dark,
    :system
    ], _suffix: true
  
  def name
    email.split('@').first.titleize
  end
end
