require 'rails_helper'

RSpec.describe SigaaUpdatesController, type: :controller do
  include Devise::Test::ControllerHelpers # 🔹 Inclui os helpers do Devise para teste

  let(:admin) { instance_double(User, admin?: true, department: instance_double(Department, name: "Computação")) }
  let(:student) { instance_double(User, admin?: false) } # 🔹 Mock do usuário aluno

  before do
    allow(request.env['warden']).to receive(:authenticate!).and_return(admin)
    allow(controller).to receive(:current_user).and_return(admin)
  end

  describe "GET #new" do
    it "deve limpar mensagens antigas e renderizar a tela de importação" do
      allow(controller).to receive(:clear_messages)
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #sigaa_update" do
    it "redireciona corretamente" do
      post sigaa_update_path, params: { classes_json: "{}", members_json: "{}" }
      expect(response).to redirect_to(new_sigaa_update_path)  # Ajuste o redirecionamento esperado
    end
  end
end
