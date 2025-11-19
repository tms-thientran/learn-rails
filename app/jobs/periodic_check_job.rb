class PeriodicCheckJob
  include Sidekiq::Job

  def perform
    # Job này sẽ chạy mỗi 5 phút
    Rails.logger.info "=== Periodic Check Job running at #{Time.current} ==="

    # Đếm tổng số tasks
    total_tasks = Task.count
    Rails.logger.info "Total tasks: #{total_tasks}"

    # Đếm số tasks chưa hoàn thành
    incomplete_tasks = Task.where(completed_at: nil).count
    Rails.logger.info "Incomplete tasks: #{incomplete_tasks}"

    # Đếm số tasks đã hoàn thành
    completed_tasks = Task.where.not(completed_at: nil).count
    Rails.logger.info "Completed tasks: #{completed_tasks}"

    # Tìm tasks quá hạn (có deadline và chưa hoàn thành)
    overdue_tasks = Task.where("deadline_time < ? AND completed_at IS NULL", Time.current)
    if overdue_tasks.any?
      Rails.logger.info "⚠️ Overdue tasks: #{overdue_tasks.count}"
      overdue_tasks.each do |task|
        Rails.logger.info "  - Task ##{task.id}: #{task.name} (deadline: #{task.deadline_time})"
      end
    end

    Rails.logger.info "=== Periodic Check Job completed ==="
  end
end
