require 'rails_helper'

RSpec.describe Form, type: :model do
  # Associações
  it { should belong_to(:school_class) }
  it { should belong_to(:form_template) }
  it { should have_many(:responses).dependent(:destroy) }

  # Validações
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:school_class) }
  it { should validate_presence_of(:form_template) }
  it { should validate_presence_of(:target_audience) }

  describe 'Custom Validations' do
    let(:department) { create(:department) }
    let(:other_department) { create(:department) }
    let(:subject) { create(:subject, department: department) }
    let(:other_subject) { create(:subject, department: other_department) }
    let(:school_class) { create(:school_class, subject: subject, semester: "2023/1") }
    let(:form_template) { create(:form_template, department: department) }

    context 'when form_template and school_class belong to different departments' do
      let(:form_template_with_other_department) { create(:form_template, department: other_department) }
      let(:form_with_invalid_department) { build(:form, school_class: school_class, form_template: form_template_with_other_department) }

      it 'adds an error for form_template' do
        form_with_invalid_department.valid?
        expect(form_with_invalid_department.errors[:form_template]).to include('deve pertencer ao mesmo departamento da turma')
      end
    end
  end

  # Métodos de Instância
  describe '#questions' do
    let(:form_template) { create(:form_template, questions_array: ['Question 1', 'Question 2']) }
    let(:form) { create(:form, form_template: form_template) }

    it 'returns the questions from the form_template' do
      expect(form.questions).to eq(['Question 1', 'Question 2'])
    end
  end

  describe '#department' do
    let(:subject) { create(:subject, department: create(:department)) }
    let(:school_class) { create(:school_class, subject: subject) }
    let(:form) { create(:form, school_class: school_class) }

    it 'returns the department of the school_class' do
      expect(form.department).to eq(school_class.department)
    end
  end
end
