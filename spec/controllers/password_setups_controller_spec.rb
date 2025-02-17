require 'rails_helper'

RSpec.describe PasswordSetupsController, type: :controller do
  let(:user) { instance_double(User, force_password_change?: true, update_with_password: true, update!: true) }

  before do
    # Mockando o login do usuário sem usar o Devise diretamente
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe "GET #edit" do
    context "quando o usuário precisa mudar a senha" do
      it "deve renderizar a view edit" do
        # Stubando o método force_password_change? para retornar true
        allow(user).to receive(:force_password_change?).and_return(true)

        # Fazendo a requisição GET
        get :edit

        # Verificando se a view edit foi renderizada
        expect(response).to render_template(:edit)
      end
    end

    context "quando o usuário não precisa mudar a senha" do
      it "deve redirecionar para a página inicial" do
        # Stubando o método force_password_change? para retornar false
        allow(user).to receive(:force_password_change?).and_return(false)

        # Fazendo a requisição GET
        get :edit

        # Verificando se ocorreu o redirecionamento para a página inicial
        expect(response).to redirect_to(authenticated_root_path)
      end
    end
  end

  describe "PATCH #update" do
    context "quando a senha é atualizada com sucesso" do
      let(:valid_params) do
        { user: { current_password: 'current_password', password: 'newpassword', password_confirmation: 'newpassword' } }
      end

      it "deve atualizar a senha e redirecionar para a página inicial" do
        # Stubando o método update_with_password para retornar true
        allow(user).to receive(:update_with_password).and_return(true)

        # Stubando o método force_password_change para retornar false após a atualização
        allow(user).to receive(:update!).with(force_password_change: false).and_return(true)

        # Stubando o método bypass_sign_in para garantir que ele seja chamado
        allow(controller).to receive(:bypass_sign_in).with(user)

        # Fazendo a requisição PATCH
        patch :update, params: valid_params

        # Verificando se o redirecionamento ocorreu
        expect(response).to redirect_to(authenticated_root_path)

        # Verificando a mensagem de sucesso
        expect(flash[:notice]).to eq("Senha definida com sucesso!")

        # Verificando se o método update! foi chamado
        expect(user).to have_received(:update!).with(force_password_change: false)

        # Verificando se o método bypass_sign_in foi chamado
        expect(controller).to have_received(:bypass_sign_in).with(user)
      end
    end

    context "quando a senha não é atualizada" do
      let(:invalid_params) do
        { user: { current_password: 'current_password', password: 'newpassword', password_confirmation: 'wrongpassword' } }
      end

      it "deve renderizar o formulário edit com status unprocessable_entity" do
        # Stubando o método update_with_password para retornar false, simulando falha na atualização
        allow(user).to receive(:update_with_password).and_return(false)

        # Fazendo a requisição PATCH
        patch :update, params: invalid_params

        # Verificando se o template edit foi renderizado novamente
        expect(response).to render_template(:edit)

        # Verificando o status da resposta
        expect(response.status).to eq(422)
      end
    end
  end

  describe "before_action :ensure_password_change_required" do
    context "quando o usuário não precisa mudar a senha" do
      it "deve redirecionar para a página inicial" do
        # Stubando o método force_password_change? para retornar false
        allow(user).to receive(:force_password_change?).and_return(false)

        # Fazendo a requisição GET
        get :edit

        # Verificando se ocorreu o redirecionamento para a página inicial
        expect(response).to redirect_to(authenticated_root_path)
      end
    end

    context "quando o usuário precisa mudar a senha" do
      it "não deve redirecionar e deve permitir o acesso à edição" do
        # Stubando o método force_password_change? para retornar true
        allow(user).to receive(:force_password_change?).and_return(true)

        # Fazendo a requisição GET
        get :edit

        # Verificando se o redirecionamento não ocorreu
        expect(response).not_to redirect_to(authenticated_root_path)
      end
    end
  end
end