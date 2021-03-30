class Place < ApplicationRecord
  belongs_to :breadboard, touch: true
  has_many :affordances, dependent: :destroy
  has_many :connections, class_name: 'Affordance', foreign_key: :connection_id, dependent: :nullify
  
  accepts_nested_attributes_for :affordances, allow_destroy: true, reject_if: proc { |affordance| affordance[:name].blank? }
  
  validates :name, presence: true
  
  default_scope -> { order(:position)}
end
