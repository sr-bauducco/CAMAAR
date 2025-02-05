require 'rails_helper'

RSpec.describe "Forms", type: :request do
  let(:admin) { create(:user, role: :admin) }
  let(:participant) { create(:user, role: :participant) }

  describe "GET /index" do
    it "permite acesso apenas para administradores" do
      sign_in admin
      get forms_path
      expect(response).to have_http_status(:success)
    end

    it "impede participantes de acessar" do
      sign_in participant
      get forms_path
      expect(response).to have_http_status(:forbidden)
    end
  end
end
