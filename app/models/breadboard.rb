class Breadboard < ApplicationRecord
  belongs_to :user
  has_many :places, dependent: :destroy
  
  validates :name, presence: true
  default_scope -> { order(updated_at: :desc)}
end
