class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email, limit: 255, null: false, index: { unique: true }
      t.string :password_digest, limit: 255, null: false
      t.string :full_name, limit: 50
      t.integer :role, default: 0, null: false

      t.timestamps
    end
  end
end
