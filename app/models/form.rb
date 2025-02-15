class Form < ApplicationRecord
  # Associações
  belongs_to :school_class
  belongs_to :form_template
  has_many :responses, dependent: :destroy

  # Validações
  validates :status, presence: true
  validates :school_class, presence: true
  validates :form_template, presence: true
  validates :target_audience, presence: true
  validate :template_belongs_to_same_department
  validate :school_class_belongs_to_same_department

  # Enum para status do formulário
  enum :status, { draft: 0, active: 1, closed: 2 }, default: :draft

  # Enum para o público-alvo do formulário
  enum :target_audience, { students: 0, teachers: 1 }, default: :students

  # Definindo os enums para status
  self.defined_enums = { status: { draft: 0, active: 1, closed: 2 } }

  # Métodos auxiliares

  # Retorna as questões do template do formulário
  def questions
    form_template.questions_array
  end

  # Retorna o departamento da turma
  def department
    school_class.department
  end

  private

  # Valida se o template do formulário pertence ao mesmo departamento da turma
  def template_belongs_to_same_department
    if form_template && school_class && form_template.department != school_class.department
      errors.add(:form_template, "deve pertencer ao mesmo departamento da turma")
    end
  end

  # Valida se a turma pertence ao mesmo departamento da disciplina
  def school_class_belongs_to_same_department
    if school_class && school_class.department != school_class.subject.department
      errors.add(:school_class, "deve pertencer ao mesmo departamento da disciplina")
    end
  end
end
