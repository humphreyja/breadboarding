class AddPositionToPlaces < ActiveRecord::Migration[6.1]
  def change
    add_column :places, :position, :integer, default: 1
  end
end
