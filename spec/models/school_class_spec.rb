require 'rails_helper'

RSpec.describe SchoolClass, type: :model do
  # Associações
  it { should belong_to(:subject) }
  it { should have_many(:enrollments).dependent(:destroy) }
  it { should have_many(:users).through(:enrollments) }
  it { should have_many(:forms).dependent(:destroy) }

  # Validações
  it { should validate_presence_of(:semester) }
  it { should validate_presence_of(:subject) }

  # Métodos de instância
  describe '#department' do
    it 'returns the department of the associated subject' do
      subject = create(:subject, department: 'Science')
      school_class = create(:school_class, subject: subject)

      expect(school_class.department).to eq('Science')
    end
  end

  describe '#name_with_subject' do
    it 'returns a string with the subject name and semester' do
      subject = create(:subject, name: 'Math')
      school_class = create(:school_class, semester: '2025.1', subject: subject)

      expect(school_class.name_with_subject).to eq('Math - 2025.1')
    end
  end

  describe '#teachers' do
    it 'returns the users who are teachers for this class' do
      school_class = create(:school_class)
      teacher = create(:user)
      create(:enrollment, school_class: school_class, user: teacher, teacher_id: teacher.id)

      expect(school_class.teachers).to include(teacher)
    end
  end

  describe '#students' do
    it 'returns the users who are students for this class' do
      school_class = create(:school_class)
      student = create(:user)
      create(:enrollment, school_class: school_class, user: student)

      expect(school_class.students).to include(student)
    end

    it 'does not include teachers in the students list' do
      school_class = create(:school_class)
      teacher = create(:user)
      student = create(:user)

      create(:enrollment, school_class: school_class, user: teacher, teacher_id: teacher.id)
      create(:enrollment, school_class: school_class, user: student)

      expect(school_class.students).to include(student)
      expect(school_class.students).not_to include(teacher)
    end
  end
end
