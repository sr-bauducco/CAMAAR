require 'rails_helper'

RSpec.describe PasswordSetupsController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user # Assume que você está usando Devise para autenticação
  end

  describe "GET #edit" do
    context "quando o usuário está autenticado e precisa mudar a senha" do
      it "deve renderizar a view edit" do
        allow(user).to receive(:force_password_change?).and_return(true)  # Simula que o usuário precisa mudar a senha
        get :edit
        expect(response).to render_template(:edit)
      end
    end

    context "quando o usuário não precisa mudar a senha" do
      it "deve redirecionar para a página inicial" do
        allow(user).to receive(:force_password_change?).and_return(false)  # Simula que o usuário não precisa mudar a senha
        get :edit
        expect(response).to redirect_to(authenticated_root_path)
      end
    end
  end

  describe "PATCH #update" do
    context "quando a senha é atualizada com sucesso" do
      let(:valid_params) do
        { user: { current_password: user.password, password: 'newpassword', password_confirmation: 'newpassword' } }
      end

      it "deve atualizar a senha e redirecionar para a página inicial" do
        patch :update, params: valid_params
        expect(response).to redirect_to(authenticated_root_path)
        expect(flash[:notice]).to eq("Senha definida com sucesso!")
        expect(user.reload.force_password_change).to be_falsey
      end
    end

    context "quando a senha não é atualizada" do
      let(:invalid_params) do
        { user: { current_password: user.password, password: 'newpassword', password_confirmation: 'wrongpassword' } }
      end

      it "deve renderizar o formulário edit com status unprocessable_entity" do
        patch :update, params: invalid_params
        expect(response).to render_template(:edit)
        expect(response.status).to eq(422)  # Verifica se o status de erro foi retornado
      end
    end
  end

  describe "before_action :ensure_password_change_required" do
    context "quando o usuário não precisa mudar a senha" do
      it "deve redirecionar para a página inicial" do
        allow(user).to receive(:force_password_change?).and_return(false)
        get :edit
        expect(response).to redirect_to(authenticated_root_path)
      end
    end

    context "quando o usuário precisa mudar a senha" do
      it "não deve redirecionar e deve permitir o acesso à edição" do
        allow(user).to receive(:force_password_change?).and_return(true)
        get :edit
        expect(response).not_to redirect_to(authenticated_root_path)
      end
    end
  end
end
