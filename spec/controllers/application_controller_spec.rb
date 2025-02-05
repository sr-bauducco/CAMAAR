require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: "OK"
    end
  end

  let(:user) { instance_double("User", force_password_change?: false) }
  let(:devise_sanitizer) { instance_double("Devise::ParameterSanitizer") }

  before do
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:devise_controller?).and_return(true)
    allow(controller).to receive(:devise_parameter_sanitizer).and_return(devise_sanitizer)
    allow(devise_sanitizer).to receive(:permit)
  end

  describe "before actions" do
    it "chama authenticate_user! antes de qualquer ação" do
      expect(controller).to receive(:authenticate_user!)
      get :index
    end

    it "configura os parâmetros permitidos se for um Devise Controller" do
      expect(devise_sanitizer).to receive(:permit).with(:sign_up, keys: [:name, :registration_number, :role, :department_id])
      expect(devise_sanitizer).to receive(:permit).with(:account_update, keys: [:name])
      get :index
    end
  end

  describe "#after_sign_in_path_for" do
    context "quando o usuário precisa mudar a senha" do
      it "redireciona para a página de configuração de senha" do
        allow(user).to receive(:force_password_change?).and_return(true)
        expect(controller.send(:after_sign_in_path_for, user)).to eq(edit_password_setup_path)
      end
    end

    context "quando o usuário não precisa mudar a senha" do
      it "redireciona para a última página acessada ou para a raiz autenticada" do
        allow(controller).to receive(:stored_location_for).with(user).and_return(nil)
        expect(controller.send(:after_sign_in_path_for, user)).to eq(authenticated_root_path)
      end
    end
  end
end
