class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.text :content, null: false
      t.integer :status, default: 0
      t.integer :priority, default: 0
      t.bigint :parent_id
      t.datetime :start_time
      t.datetime :deadline_time

      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.timestamps
    end
  end
end
