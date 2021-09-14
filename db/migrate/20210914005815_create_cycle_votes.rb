class CreateCycleVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :cycles do |t|
      t.integer :number, null: false
      t.bigint :published_id
      t.references :domain, foreign_key: true
      t.date :date, null: false
      
      t.jsonb :voting_data_hash
      t.timestamps
    end
    
    create_table :basecamp_sessions do |t|
      t.string :token
      t.boolean :authenticated, default: false
      t.bigint :account_id
      t.bigint :pitch_project_id
      t.bigint :pitch_deck_id
      t.bigint :pitch_category_id
      t.references :user, foreign_key: true
      t.references :domain, foreign_key: true
      t.timestamps
    end
  end
end
