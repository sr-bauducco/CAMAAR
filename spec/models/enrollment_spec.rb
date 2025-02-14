require 'rails_helper'

RSpec.configure do |config|
  config.before(:each) do
    User.delete_all
  end
end

RSpec.describe Enrollment, type: :model do
  let(:student) { create(:user, :student) }
  let(:teacher) { create(:user, :teacher) }
  let(:school_class) { create(:school_class) }

  describe "associações" do
    it { should belong_to(:user).optional }
    it { should belong_to(:teacher).optional }
    it { should belong_to(:school_class) }
  end

  describe "validações" do
    it "é válido com um student ou teacher e uma school_class" do
      department = create(:department)  # Cria um department
      subject = create(:subject, department: department)  # Cria um subject associado ao department
      school_class = create(:school_class, subject: subject)  # Cria uma school_class associada ao subject

      # Cria o enrollment com um student
      enrollment = Enrollment.new(user: student, school_class: school_class)
      expect(enrollment).to be_valid

      # Cria o enrollment com um teacher
      enrollment.teacher = teacher
      enrollment.user = nil
      expect(enrollment).to be_valid
    end

    it "não é válido sem school_class" do
      enrollment = Enrollment.new(school_class: nil)
      expect(enrollment).to_not be_valid
      expect(enrollment.errors[:school_class]).to include("não pode ficar em branco")
    end

    it "não é válido sem user ou teacher" do
      enrollment = Enrollment.new(school_class: school_class)
      expect(enrollment).to_not be_valid
      expect(enrollment.errors[:base]).to include("É necessário especificar um aluno ou professor")
    end

    it "não é válido com ambos user e teacher" do
      enrollment = Enrollment.new(user: student, teacher: teacher, school_class: school_class)
      expect(enrollment).to_not be_valid
      expect(enrollment.errors[:base]).to include("Não é possível especificar aluno e professor ao mesmo tempo")
    end

    it "não é válido se o teacher não for um professor" do
      non_teacher_user = create(:user, :student)  # criando um usuário que não é professor
      enrollment = Enrollment.new(teacher: non_teacher_user, school_class: school_class)
      expect(enrollment).to_not be_valid
      expect(enrollment.errors[:teacher]).to include("deve ser um professor")
    end

    it "não é válido se o user não for um estudante" do
      non_student_user = create(:user, :teacher)  # criando um usuário que não é estudante
      enrollment = Enrollment.new(user: non_student_user, school_class: school_class)
      expect(enrollment).to_not be_valid
      expect(enrollment.errors[:user]).to include("deve ser um estudante")
    end

    it "não pode duplicar um user ou teacher em uma mesma turma" do
      Enrollment.create!(user: student, school_class: school_class)

      enrollment = Enrollment.new(user: student, school_class: school_class)
      expect(enrollment).to_not be_valid
      expect(enrollment.errors[:base]).to include("Usuário já está vinculado a esta turma")
    end
  end

  describe "callbacks" do
    it "define o role como 'student' se não houver teacher" do
      enrollment = Enrollment.new(user: student, school_class: school_class)
      expect(enrollment.role).to eq("student")
    end

    it "define o role como 'teacher' se houver teacher" do
      enrollment = Enrollment.new(teacher: teacher, school_class: school_class)
      expect(enrollment.role).to eq("teacher")
    end

    it "chama o set_role antes da validação" do
      enrollment = Enrollment.new(user: student, school_class: school_class)
      enrollment.valid?
      expect(enrollment.role).to eq("student")
    end

    it "chama ensure_correct_user_type antes da validação" do
      enrollment = Enrollment.new(user: student, school_class: school_class)
      enrollment.valid?
      # Espera que a função de callback tenha passado, então sem erros.
      expect(enrollment.errors[:user]).to be_empty
    end
  end
end
