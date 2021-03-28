class CreateDomains < ActiveRecord::Migration[6.1]
  def change
    create_table :domains do |t|
      t.string :name, unique: true
      t.timestamps
    end
    
    add_reference :users, :domain, foreign_key: true
  end
end
