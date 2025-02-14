require 'rails_helper'

RSpec.describe Response, type: :model do
  describe 'basic model validations' do
    it { should belong_to(:form) }
    it { should belong_to(:user) }

    it { should validate_presence_of(:answers) }
    it { should validate_presence_of(:form) }
    it { should validate_presence_of(:user) }

    describe '#answers_array' do
      let(:response) { build(:response, answers: answers) }

      context 'when answers is nil' do
        let(:answers) { nil }
        it 'returns an empty hash' do
          expect(response.answers_array).to eq({})
        end
      end

      context 'when answers is a JSON string' do
        let(:answers) { '{"1": "Resposta 1"}' }
        it 'parses the JSON string' do
          expect(response.answers_array).to eq({ "1" => "Resposta 1" })
        end
      end

      context 'when answers is already a hash' do
        let(:answers) { { "1" => "Resposta 1" } }
        it 'returns the hash as is' do
          expect(response.answers_array).to eq({ "1" => "Resposta 1" })
        end
      end
    end
  end
end
