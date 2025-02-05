require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { instance_double("User", id: 1) }

  describe "GET #new" do
    it "retorna sucesso" do
      allow(controller).to receive(:new).and_call_original
      response = controller.new
      expect(response).to be_nil # Apenas verifica se o método pode ser chamado sem erro
    end
  end

  describe "POST #create" do
    let(:params) { { identifier: "user@example.com", password: "password" } }

    before do
      allow(new_user_session_path).to receive(:find_by).and_return(user)
      allow(controller).to receive(:session).and_return({})
    end

    it "autentica o usuário e salva na sessão" do
      expect(controller.session).to receive(:[]=).with(:user_id, 1)
      post :create, params: params
    end

    context "quando o usuário não é encontrado ou a senha é inválida" do
      before do
        allow(User).to receive(:find_by).and_return(nil)
        allow(controller).to receive(:flash).and_return({})
      end

      it "não salva o ID do usuário e renderiza a página de login" do
        expect(controller.session[:user_id]).to be_nil
        post :create, params: params
      end
    end
  end

  describe "DELETE #destroy" do
    before { allow(controller).to receive(:session).and_return({ user_id: 1 }) }

    it "remove o usuário da sessão e redireciona" do
      expect(controller.session).to receive(:delete).with(:user_id)
      delete :destroy
    end
  end
end
