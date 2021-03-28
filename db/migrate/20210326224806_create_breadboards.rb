class CreateBreadboards < ActiveRecord::Migration[6.1]
  def change
    create_table :breadboards do |t|
      t.string :name
      t.references :user, foreign_key: true
      t.references :domain, foreign_key: true

      t.timestamps
    end
    
    create_table :places do |t|
      t.references :breadboard, foreign_key: true
      t.string :name
    end
    
    create_table :affordances do |t|
      t.references :place, foreign_key: true
      t.integer :position, default: 0
      t.string :name
      
      t.references :connection, foreign_key: { to_table: :places }
    end
  end
end
