require 'rails_helper'

RSpec.describe Task, type: :model do
  it "Belong to a project" do
    color = create(:color)

    user = create(:user)
    project = create(:project, user: user, color: color)
    task = create(:task, project: project, user: user)

    expect(task.project).to eq(project)
  end
end
