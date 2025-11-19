class AddCompletedAtToTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :completed_at, :datetime, after: :project_id
  end
end
