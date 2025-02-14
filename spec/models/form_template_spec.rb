require 'rails_helper'

RSpec.describe FormTemplate, type: :model do
  # Associações
  it { should belong_to(:department) }
  it { should have_many(:forms).dependent(:restrict_with_error) }

  # Validações
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:questions) }
  it { should validate_presence_of(:department) }

  describe 'Custom Validations' do
    context 'when questions format is invalid' do
      it 'adds an error when questions is not a valid JSON array' do
        form_template = build(:form_template, questions: "invalid_json") # String inválida
        form_template.valid?
        expect(form_template.errors[:questions]).to include("formato inválido")
      end

      it 'adds an error when questions is not an array' do
        form_template = build(:form_template, questions: { "text" => "Question 1", "answer_type" => "text" }.to_json) # Não é um array
        form_template.valid?
        expect(form_template.errors[:questions]).to include("deve ser um array de questões")
      end

      it 'adds an error when each question does not have text and answer_type' do
        invalid_question = [{ "text" => nil, "answer_type" => "text" }]
        form_template = build(:form_template, questions: invalid_question.to_json) # Questão inválida
        form_template.valid?
        expect(form_template.errors[:questions]).to include("cada questão deve ter texto e tipo de resposta")
      end

      it 'adds an error when answer_type is invalid' do
        invalid_question = [{ "text" => "Question 1", "answer_type" => "invalid_type" }]
        form_template = build(:form_template, questions: invalid_question.to_json) # Tipo inválido
        form_template.valid?
        expect(form_template.errors[:questions]).to include("tipo de resposta inválido")
      end
    end

    context 'when questions is an empty array' do
      it 'does not add an error for new records with empty questions array' do
        form_template = build(:form_template, questions: [].to_json) # Array vazio
        expect(form_template).to be_valid
      end
    end
  end

  # Métodos de Instância
  describe '#questions_array' do
    it 'returns questions as an array when questions is a stringified JSON' do
      questions_json = '[{"text": "Question 1", "answer_type": "text"}]'
      form_template = build(:form_template, questions: questions_json)
      expect(form_template.questions_array).to eq([{"text" => "Question 1", "answer_type" => "text"}])
    end

    it 'returns questions as an array when questions is already an array' do
      questions_array = [{"text" => "Question 1", "answer_type" => "text"}]
      form_template = build(:form_template, questions: questions_array)
      expect(form_template.questions_array).to eq(questions_array)
    end
  end
end
