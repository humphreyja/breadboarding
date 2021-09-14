class Domain < ApplicationRecord
  has_many :users
  has_many :breadboards
  has_one :basecamp_session
  has_many :cycles
end
