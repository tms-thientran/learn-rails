class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.references :user, null: false, foreign_key: true
      t.references :color, null: false, foreign_key: true
      t.bigint :parent_id

      t.timestamps
    end
  end
end
