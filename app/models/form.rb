class Form < ApplicationRecord
  belongs_to :school_class
  belongs_to :form_template
  has_many :responses, dependent: :destroy

  validates :status, presence: true
  validates :school_class, presence: true
  validates :form_template, presence: true
  validates :target_audience, presence: true
  validate :template_belongs_to_same_department
  validate :school_class_belongs_to_same_department

  enum :status, { draft: 0, active: 1, closed: 2 }, default: :draft
  enum :target_audience, { students: 0, teachers: 1 }, default: :students

  self.defined_enums = { status: { draft: 0, active: 1, closed: 2 } }

  def questions
    form_template.questions_array
  end

  def department
    school_class.department
  end

  private

  def template_belongs_to_same_department
    if form_template && school_class && form_template.department != school_class.department
      errors.add(:form_template, "deve pertencer ao mesmo departamento da turma")
    end
  end

  def school_class_belongs_to_same_department
    if school_class && school_class.department != school_class.subject.department
      errors.add(:school_class, "deve pertencer ao mesmo departamento da disciplina")
    end
  end
end
