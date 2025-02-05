class Enrollment < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :teacher, class_name: "User", optional: true
  belongs_to :school_class

  validates :school_class, presence: true
  validate :user_or_teacher_present
  validate :user_uniqueness

  before_validation :set_role
  before_validation :ensure_correct_user_type

  self.defined_enums = { role: { student: 0, teacher: 1 } }

  private

  def set_role
    self.role = teacher.present? ? :teacher : :student
  end

  def ensure_correct_user_type
    if teacher.present? && !teacher.teacher?
      errors.add(:teacher, "deve ser um professor")
    end

    if user.present? && !user.student?
      errors.add(:user, "deve ser um estudante")
    end
  end

  def user_or_teacher_present
    if user.blank? && teacher.blank?
      errors.add(:base, "É necessário especificar um aluno ou professor")
    end

    if user.present? && teacher.present?
      errors.add(:base, "Não é possível especificar aluno e professor ao mesmo tempo")
    end
  end

  def user_uniqueness
    return unless user.present? || teacher.present?

    scope = Enrollment.where(school_class_id: school_class_id)
    scope = scope.where(user_id: user_id) if user.present?
    scope = scope.where(teacher_id: teacher_id) if teacher.present?
    scope = scope.where.not(id: id) if persisted?

    if scope.exists?
      errors.add(:base, "Usuário já está vinculado a esta turma")
    end
  end
end
