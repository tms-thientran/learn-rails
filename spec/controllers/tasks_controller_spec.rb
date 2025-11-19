require "rails_helper"

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:color) { create(:color) }
  let(:project) { create(:project, user: user, color: color) }
  let(:session_record) { create(:session, user: user) }

  before do
    allow(controller).to receive(:require_authentication).and_return(true)
    allow(Current).to receive(:session).and_return(session_record)
    allow(Current).to receive(:user).and_return(user)
  end

  describe "POST #create" do
    it "creates a new task" do
      post :create, params: { task: { name: "Test", content: "Demo" }, project_id: project.id }

      expect(Task.count).to eq(1)
      expect(response).to redirect_to(project_tasks_path(project))
    end
  end
end
