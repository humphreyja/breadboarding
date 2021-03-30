class AddDarkmodePreference < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :theme, :integer, default: 0
  end
end
