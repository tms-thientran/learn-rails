class ProjectsController < ApplicationController
  before_action :set_project, only: %i[edit update destroy]

  def index
    @project_count = Project.count
    @projects = Project.includes(:color).select(:id, :name, :color_id)
      .order(id: :desc).page(params[:page]).per(10)
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def update
    if @project.update(param_project)
      redirect_to projects_path, notice: "Cập nhật dự án #{@project.name} thành công", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy

    redirect_to projects_path, notice: "Dự án #{@project.name} đã bị xoá", status: :see_other
  end

  def create
    @project = Current.user.projects.new(param_project)

    if @project.save
      redirect_to projects_path, notice: "Tạo dự án thành công", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def param_project
      params.require(:project).permit(:name, :color_id)
    end

    def set_project
      @project = Project.find(params.expect(:id))
    end
end
