require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:user) { instance_double("User", student?: false, admin?: false, department_id: 1) }
  let(:form1) { instance_double("Form") }
  let(:form2) { instance_double("Form") }

  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    context "quando o usuário é um estudante" do
      before do
        allow(user).to receive(:student?).and_return(true)
        allow(controller).to receive(:pending_student_forms).and_return([form1, form2])
        get :index
      end

      it "atribui @pending_forms com os formulários pendentes do estudante" do
        expect(assigns(:pending_forms)).to eq([form1, form2])
      end
    end

    context "quando o usuário é um administrador" do
      before do
        allow(user).to receive(:admin?).and_return(true)
        allow(controller).to receive(:pending_admin_forms).and_return([form1])
        get :index
      end

      it "atribui @pending_forms com os formulários pendentes do administrador" do
        expect(assigns(:pending_forms)).to eq([form1])
      end
    end

    context "quando o usuário não é estudante nem administrador" do
      before do
        allow(controller).to receive(:pending_admin_forms).and_return([])
        get :index
      end

      it "atribui @pending_forms com uma lista vazia" do
        expect(assigns(:pending_forms)).to eq([])
      end
    end
  end
end
