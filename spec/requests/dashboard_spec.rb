require 'rails_helper'

RSpec.describe Response, type: :model do
  describe 'dashboard-related validations' do
    let(:user) { create(:user) }
    let(:form) { create(:form) }
    let(:response) { build(:response, user: user, form: form) }

    context 'when checking user enrollment' do
      it 'is invalid if the user is not enrolled in the class' do
        allow(user).to receive(:all_classes).and_return([]) # Usuário não está em nenhuma turma
        response.valid?
        expect(response.errors[:base]).to include("Usuário deve estar vinculado à turma")
      end

      it 'is valid if the user is enrolled in the class' do
        allow(user).to receive(:all_classes).and_return([form.school_class])
        expect(response).to be_valid
      end
    end
  end
end
