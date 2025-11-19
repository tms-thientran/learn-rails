class TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, only: %i[edit update destroy]

  def index
    @tasks = Task.where(project_id: params[:project_id]).where(user: Current.user).order(id: :desc).page(params[:page]).per(10)
  end

  def new
    @task = @project.tasks.new
  end

  def create
    param_task = params.require(:task).permit(:name, :content)

    @task = @project.tasks.new(param_task)
    @task.user = Current.user

    if @task.save
      TaskNotificationJob.perform_async(@task.id)
      redirect_to project_tasks_path, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    param_task = params.require(:task).permit(:name, :content, :completed)

    # Kiểm tra nếu đang update từ form edit (có name/content) hay từ checkbox toggle
    @is_form_update = params[:task][:name].present? || params[:task][:content].present?

    # Xử lý toggle completed
    if params[:task][:completed].present?
      param_task[:completed_at] = params[:task][:completed] == "1" ? Time.current : nil
      param_task.delete(:completed)
    end

    if @task.update(param_task)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to project_tasks_path(@project) }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to project_tasks_path(@project), status: :see_other }
    end
  end

  private
    def set_project
      @project = Current.user.projects.find(params[:project_id])
    end

    def set_task
      @task = @project.tasks.find(params[:id])
    end
end
