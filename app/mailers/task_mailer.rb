class TaskMailer < ApplicationMailer
  def created_task_email(task)
    @task = task
    mail(to: task.user.email, subject: "Bạn vừa tạo task mới")
  end
end
