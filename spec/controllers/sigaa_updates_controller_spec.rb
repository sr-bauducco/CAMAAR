require 'rails_helper'

RSpec.describe SigaaUpdatesController, type: :controller do
  include Devise::Test::ControllerHelpers # 🔹 Inclui os helpers do Devise para teste

  let(:admin) { instance_double(User, admin?: true) }
  let(:student) { instance_double(User, role: 'student') } # 🔹 Mock do usuário aluno

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

  describe "POST #create" do
    before do
      allow(controller).to receive(:redirect_to)
      allow(controller).to receive(:flash).and_return({})
    end

    context "quando o usuário não é admin" do
      before do
        allow(controller).to receive(:current_user).and_return(student)
      end

      it "redireciona para a página inicial com alerta" do
        post :create, params: { classes_json: "{}", class_members_json: "{}" }
        expect(controller).to have_received(:redirect_to).with(authenticated_root_path)
        expect(controller.flash[:alert]).to eq("Acesso não autorizado")
      end
    end

    context "quando os arquivos JSON não são enviados" do
      it "redireciona com mensagem de erro" do
        post :create, params: {}
        expect(controller).to have_received(:redirect_to).with(new_sigaa_update_path)
        expect(controller.flash[:alert]).to eq("Por favor, selecione os arquivos JSON do SIGAA")
      end
    end

    context "quando os arquivos JSON são inválidos" do
      it "redireciona com erro de parsing" do
        post :create, params: { classes_json: "invalid_json", members_json: "invalid_json" }
        expect(controller).to have_received(:redirect_to).with(new_sigaa_update_path)
        expect(controller.flash[:alert]).to eq("Arquivo JSON inválido")
      end
    end

    context "quando os arquivos JSON são válidos" do
      let(:valid_classes_json) { "{}" }
      let(:valid_members_json) { "{}" }

      before do
        allow(controller).to receive(:process_json_files).and_return([0, 0, 0, 0])
      end

      it "cria ou atualiza disciplinas e turmas corretamente" do
        post :create, params: { classes_json: valid_classes_json, members_json: valid_members_json }
        expect(controller).to have_received(:redirect_to).with(authenticated_root_path)
        expect(controller.flash[:notice]).to include("Disciplinas atualizadas: 0")
      end

      it "não duplica usuários existentes" do
        allow(controller).to receive(:count_existing_users).and_return([1, 1])
        post :create, params: { classes_json: valid_classes_json, members_json: valid_members_json }
        expect(controller.flash[:notice]).to include("Professores existentes: 1")
        expect(controller.flash[:notice]).to include("Alunos existentes: 1")
      end

      it "remove matrículas antigas corretamente" do
        allow(controller).to receive(:remove_old_enrollments).and_return(1)
        post :create, params: { classes_json: valid_classes_json, members_json: valid_members_json }
        expect(controller.flash[:notice]).to include("Matrículas removidas: 1")
      end
    end
  end
end
