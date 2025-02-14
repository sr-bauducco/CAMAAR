require 'rails_helper'

RSpec.describe Response, type: :model do
  describe 'form template validations' do
    let(:form) { create(:form, active: true) }
    let(:user) { create(:user) }
    let(:response) { build(:response, form: form, user: user, answers: answers) }

    context 'when checking form activity' do
      it 'is invalid if the form is not active' do
        form.update(active: false)
        response.valid?
        expect(response.errors[:base]).to include("Formulário deve estar ativo para receber respostas")
      end
    end

    context 'when checking required answers' do
      let(:form_template) { create(:form_template, questions: [{ "text" => "Pergunta 1", "required" => true }]) }

      before do
        allow(form).to receive(:form_template).and_return(form_template)
      end

      it 'is invalid if required answers are missing' do
        response.answers = {} # Nenhuma resposta fornecida
        response.valid?
        expect(response.errors[:base]).to include("A questão 'Pergunta 1' é obrigatória")
      end

      it 'is valid if all required answers are present' do
        response.answers = { "0" => "Resposta válida" }.to_json
        expect(response).to be_valid
      end
    end
  end
end
