class TaskNotificationJob
  include Sidekiq::Job

  def perform(task_id)
    task = Task.find(task_id)
    TaskMailer.created_task_email(task).deliver_now
  end
end
