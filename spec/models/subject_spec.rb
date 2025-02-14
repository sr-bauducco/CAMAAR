require 'rails_helper'

RSpec.describe Subject, type: :model do
  # Associações
  it { should belong_to(:department) }
  it { should have_many(:school_classes).dependent(:restrict_with_error) }

  # Validações
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:code) }
  it { should validate_uniqueness_of(:code) }

  describe 'validations' do
    let(:department) { create(:department) }

    context 'when creating a subject' do
      it 'is valid with a unique code and valid department' do
        subject = build(:subject, department: department, code: 'MATH101')
        expect(subject).to be_valid
      end

      it 'is invalid without a department' do
        subject = build(:subject, code: 'MATH101') # department is missing
        expect(subject).not_to be_valid
        expect(subject.errors[:department]).to include("must exist")
      end

      it 'is invalid with a duplicate code' do
        create(:subject, department: department, code: 'MATH101') # Criação do subject com department
        subject = build(:subject, department: department, code: 'MATH101') # Novo subject com o mesmo código
        expect(subject).not_to be_valid
        expect(subject.errors[:code]).to include("has already been taken") # Verificação da mensagem de erro
      end
    end
  end

  describe 'associations' do
    it 'does not allow deleting a department with associated school classes' do
      department = create(:department)  # Certificando que um department válido é criado
      subject = create(:subject, department: department)  # Associando o department ao subject
      create(:school_class, subject: subject) # Criando uma school_class associada

      # Tentando excluir o department, deve gerar um erro devido à restrição
      expect { department.destroy }.to raise_error(ActiveRecord::DeleteRestrictionError)
    end
  end
end
