require 'rails_helper'

RSpec.describe Response, type: :model do
  # Associações
  it { should belong_to(:form) }
  it { should belong_to(:user) }

  # Validações de presença
  it { should validate_presence_of(:answers) }
  it { should validate_presence_of(:form) }
  it { should validate_presence_of(:user) }

  describe 'Custom Validations' do
    let(:user) { create(:user) }
    let(:school_class) { create(:school_class) }
    let(:active_form) { create(:form, active: true, user: user, school_class: school_class) }
    let(:inactive_form) { create(:form, active: false, user: user, school_class: school_class) }
    let(:form_template) { create(:form_template, questions: [{ "text" => "Question 1", "answer_type" => "text", "required" => true }].to_json) }
    let(:form_with_template) { create(:form, form_template: form_template, school_class: school_class) }

    context 'when user is not enrolled in the class' do
      it 'adds an error if the user is not enrolled in the class' do
        # Formulário com uma turma diferente do usuário
        form = create(:form, school_class: create(:school_class))
        response = build(:response, form: form, user: user, answers: { "0" => "Answer" }.to_json)

        response.valid?
        expect(response.errors[:base]).to include("Usuário deve estar vinculado à turma")
      end
    end

    context 'when the form is not active' do
      it 'adds an error if the form is not active' do
        response = build(:response, form: inactive_form, user: user, answers: { "0" => "Answer" }.to_json)

        response.valid?
        expect(response.errors[:base]).to include("Formulário deve estar ativo para receber respostas")
      end
    end

    context 'when required answers are missing' do
      it 'adds an error if a required question has no answer' do
        response = build(:response, form: form_with_template, user: user, answers: {}.to_json)

        response.valid?
        expect(response.errors[:base]).to include("A questão 'Question 1' é obrigatória")
      end

      it 'does not add an error if all required questions have answers' do
        response = build(:response, form: form_with_template, user: user, answers: { "0" => "Answer" }.to_json)

        expect(response).to be_valid
      end
    end
  end

  # Métodos de Instância
  describe '#answers_array' do
    it 'returns answers as an empty hash if answers is nil' do
      response = build(:response, answers: nil)
      expect(response.answers_array).to eq({})
    end

    it 'parses the answers string as JSON if answers is a string' do
      response = build(:response, answers: '[{"question_id": 1, "answer": "Yes"}]')
      expect(response.answers_array).to eq([{"question_id" => 1, "answer" => "Yes"}])
    end

    it 'returns answers as an array if answers is already an array' do
      response = build(:response, answers: [{"question_id" => 1, "answer" => "Yes"}])
      expect(response.answers_array).to eq([{"question_id" => 1, "answer" => "Yes"}])
    end
  end
end
