require 'rails_helper'

RSpec.describe FormTemplatesController, type: :controller do
  let(:user) { instance_double("User", department: "TI", admin?: true) }
  let(:form_template) { instance_double("FormTemplate", id: 1, department: "TI", forms: [], destroy: true) }
  let(:valid_params) { { form_template: { name: "Novo Template", questions: {} } } }
  let(:invalid_params) { { form_template: { name: "", questions: {} } } }

  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:current_user).and_return(user)
    allow(FormTemplate).to receive(:where).and_return([form_template])
    allow(FormTemplate).to receive(:new).and_return(form_template)
    allow(form_template).to receive(:save).and_return(true)
    allow(form_template).to receive(:update).and_return(true)
    allow(form_template).to receive(:destroy).and_return(true)
  end

  describe "GET #index" do
    it "atribui @form_templates corretamente" do
      get :index
      expect(assigns(:form_templates)).to eq([form_template])
    end
  end

  describe "GET #new" do
    it "instancia um novo FormTemplate" do
      get :new
      expect(assigns(:form_template)).to eq(form_template)
    end
  end

  describe "POST #create" do
    context "com parâmetros válidos" do
      it "salva o template e redireciona" do
        expect(form_template).to receive(:save).and_return(true)
        post :create, params: valid_params
        expect(response).to redirect_to(form_templates_path)
      end
    end

    context "com parâmetros inválidos" do
      it "renderiza new com status 422" do
        allow(form_template).to receive(:save).and_return(false)
        post :create, params: invalid_params
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #update" do
    before { allow(form_template).to receive(:update).and_return(true) }

    context "com parâmetros válidos" do
      it "atualiza o template e redireciona" do
        patch :update, params: { id: 1, form_template: { name: "Novo Nome" } }
        expect(response).to redirect_to(form_templates_path)
      end
    end

    context "com parâmetros inválidos" do
      it "renderiza edit com status 422" do
        allow(form_template).to receive(:update).and_return(false)
        patch :update, params: { id: 1, form_template: { name: "" } }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    context "quando o template não tem forms associados" do
      it "exclui o template e redireciona" do
        delete :destroy, params: { id: 1 }
        expect(response).to redirect_to(form_templates_path)
      end
    end

    context "quando o template tem forms associados" do
      it "não permite a exclusão e redireciona com alerta" do
        allow(form_template).to receive(:forms).and_return([double])
        delete :destroy, params: { id: 1 }
        expect(response).to redirect_to(form_templates_path)
        expect(flash[:alert]).to eq("Não é possível excluir um template que já está em uso.")
      end
    end
  end
end
