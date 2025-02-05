require 'rails_helper'

RSpec.describe SigaaUpdatesController, type: :controller do
  include Devise::Test::ControllerHelpers # 🔹 Inclui os helpers do Devise para teste

  let(:admin) { create(:user, :admin) } # 🔹 Criando usuário admin válido

  before do
    sign_in admin # 🔹 Autentica o usuário
  end

  describe "GET #new" do
    it "deve limpar mensagens antigas e renderizar a tela de importação" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end
end




/#describe "POST #create" do
    context "quando o usuário não é admin" do
      before do
        sign_out admin
        sign_in student
      end

      it "redireciona para a página inicial com alerta" do
        post :create, params: { classes_json: valid_classes_json, members_json: valid_members_json }
        expect(response).to redirect_to(authenticated_root_path)
        expect(flash[:alert]).to eq("Acesso não autorizado")
      end
    end

    context "quando os arquivos JSON não são enviados" do
      it "redireciona com mensagem de erro" do
        post :create, params: {}
        expect(response).to redirect_to(new_sigaa_update_path)
        expect(flash[:alert]).to eq("Por favor, selecione os arquivos JSON do SIGAA")
      end
    end

    context "quando os arquivos JSON são inválidos" do
      it "redireciona com erro de parsing" do
        post :create, params: { classes_json: "invalid_json", members_json: "invalid_json" }
        expect(response).to redirect_to(new_sigaa_update_path)
        expect(flash[:alert]).to eq("Arquivo JSON inválido")
      end
    end

    context "quando os arquivos JSON são válidos" do
      it "cria ou atualiza disciplinas e turmas corretamente" do
        expect {
          post :create, params: { classes_json: StringIO.new(valid_classes_json), members_json: StringIO.new(valid_members_json) }
        }.to change(Subject, :count).by(1)
                                    .and change(SchoolClass, :count).by(1)

        expect(response).to redirect_to(authenticated_root_path)
        expect(flash[:notice]).to include("Disciplinas atualizadas: 0")
      end

      it "cria novos professores e alunos" do
        expect {
          post :create, params: { classes_json: StringIO.new(valid_classes_json), members_json: StringIO.new(valid_members_json) }
        }.to change(User, :count).by(2) # 1 professor + 1 aluno

        expect(flash[:passwords]).to be_present
      end

      it "não duplica usuários existentes" do
        create(:user, registration_number: "12345", role: :teacher)
        create(:user, registration_number: "54321", role: :student)

        expect {
          post :create, params: { classes_json: StringIO.new(valid_classes_json), members_json: StringIO.new(valid_members_json) }
        }.to_not change(User, :count)

        expect(flash[:notice]).to include("Professores existentes: 1")
        expect(flash[:notice]).to include("Alunos existentes: 1")
      end

      it "remove matrículas antigas corretamente" do
        old_enrollment = create(:enrollment, school_class: school_class, user: create(:user, role: :student))
        expect {
          post :create, params: { classes_json: StringIO.new(valid_classes_json), members_json: StringIO.new(valid_members_json) }
        }.to change(Enrollment, :count).by(1) # Novo aluno entra, mas um antigo sai

        expect(flash[:notice]).to include("Matrículas removidas: 1")
      end
    end
  end
end
#/