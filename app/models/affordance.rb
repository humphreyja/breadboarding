class Affordance < ApplicationRecord
  belongs_to :place, touch: true
  has_one :breadboard, through: :place
  belongs_to :connection, class_name: 'Place', optional: true
  
  validates :name, presence: true
  
  default_scope -> { order(:id)}
  
  def connected_to_direction
    return nil if connection.nil?
    
    if place.position < 4
      return :right if connection.position == place.position + 1
      return :down_right if connection.position == place.position + 5
      
    elsif place.position == 4 && connection.position == 5
      return :wrap
    end
  end
  
  def connection_position
    return nil if connection.nil?
    connection.position
  end
  
  def connection_position=(val)
    return if breadboard.nil?
    self.connection = breadboard.places.find_by(position: val)
  end
end
