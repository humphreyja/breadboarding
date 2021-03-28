class Domain < ApplicationRecord
  has_many :users
  has_many :breadboards
end
