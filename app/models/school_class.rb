class SchoolClass < ApplicationRecord
  # Associações
  belongs_to :subject
  has_many :enrollments, dependent: :destroy
  has_many :users, through: :enrollments
  has_many :forms, dependent: :destroy

  # Validações
  validates :semester, presence: true
  validates :subject, presence: true

  # Métodos

  # Retorna o departamento da disciplina associada
  def department
    subject.department
  end

  # Retorna o nome da turma com a disciplina e semestre
  def name_with_subject
    "#{subject.name} - #{semester}"
  end

  # Retorna os professores associados à turma
  def teachers
    User.joins(:teachings).where(enrollments: { school_class_id: id })
  end

  # Retorna os alunos associados à turma
  def students
    User.joins(:enrollments).where(enrollments: { school_class_id: id, teacher_id: nil })
  end
end
