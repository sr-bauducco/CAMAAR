require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  let(:user) { instance_double("User", email: "user@example.com") }

  before do
    # Configurando a sessão diretamente
    session[:reset_password_email] = "user@example.com"
  end

  describe "GET #new" do
    it "deve renderizar a view new" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "quando o email existe" do
      before do
        # Stubando o método User.find_by para retornar o usuário simulado
        allow(User).to receive(:find_by).with(email: "user@example.com").and_return(user)
      end

      it "deve redirecionar para edit_password_reset_path com uma mensagem de sucesso" do
        post :create, params: { email: "user@example.com" }

        # Verificando se o redirecionamento e a mensagem de sucesso ocorreram
        expect(response).to redirect_to(edit_password_reset_path)
        expect(flash[:notice]).to eq("Por favor, defina sua nova senha.")
      end
    end

    context "quando o email não existe" do
      before do
        # Stubando o método User.find_by para retornar nil
        allow(User).to receive(:find_by).with(email: "invalid@example.com").and_return(nil)
      end

      it "deve renderizar a view new com uma mensagem de erro" do
        post :create, params: { email: "invalid@example.com" }

        # Verificando se a renderização e a mensagem de erro ocorreram
        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to eq("Email não encontrado.")
      end
    end
  end

  describe "GET #edit" do
    context "quando o usuário existe" do
      before do
        # Stubando o User.find_by dentro do controller
        allow(User).to receive(:find_by).with(email: "user@example.com").and_return(user)
      end

      it "deve renderizar a view edit" do
        get :edit
        expect(response).to render_template(:edit)
      end
    end

    context "quando o usuário não existe" do
      before do
        # Stubando User.find_by para retornar nil
        allow(User).to receive(:find_by).with(email: "nonexistent@example.com").and_return(nil)
      end

      it "deve redirecionar para new_password_reset_path com mensagem de erro" do
        # Simulando a sessão com um email inválido
        session[:reset_password_email] = "nonexistent@example.com"

        get :edit

        expect(response).to redirect_to(new_password_reset_path)
        expect(flash[:alert]).to eq("Por favor, informe seu email novamente.")
      end
    end
  end

  describe "PATCH #update" do
    context "quando a senha é atualizada com sucesso" do
      before do
        # Stubando User.find_by para retornar um usuário válido
        allow(User).to receive(:find_by).with(email: "user@example.com").and_return(user)
        # Stubando o método update do usuário para retornar true
        allow(user).to receive(:update).and_return(true)
      end

      it "deve redirecionar para new_user_session_path com mensagem de sucesso" do
        patch :update, params: { user: { password: "newpassword", password_confirmation: "newpassword" } }

        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:notice]).to eq("Senha atualizada com sucesso! Por favor, faça login.")
      end
    end

    context "quando a atualização da senha falha" do
      before do
        # Stubando User.find_by para retornar um usuário válido
        allow(User).to receive(:find_by).with(email: "user@example.com").and_return(user)
        # Stubando o método update do usuário para retornar false (falha)
        allow(user).to receive(:update).and_return(false)
      end

      it "deve renderizar a view edit com status unprocessable_entity" do
        patch :update, params: { user: { password: "newpassword", password_confirmation: "mismatchpassword" } }

        # Verificando se o formulário edit é renderizado novamente
        expect(response).to render_template(:edit)
        expect(response.status).to eq(422)
      end
    end
  end
end