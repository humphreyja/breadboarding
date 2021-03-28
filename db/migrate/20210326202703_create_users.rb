class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, unique: true, null: false
      t.string :password_digest
      t.string :reset_password_token, unique: true
      t.datetime :reset_password_sent_at

      t.integer :failed_attempts, default: 0
      t.integer :sign_in_count, default: 0
      t.datetime :locked_at
      
      t.string :last_seen_from_ip_address
      t.datetime :last_seen_at

      t.datetime :accepted_privacy_policy_at
      
      t.boolean :domain_admin, default: false
      t.boolean :enabled, default: true

      t.timestamps
    end
  end
end
