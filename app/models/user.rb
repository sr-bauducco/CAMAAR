class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associações
  belongs_to :department, optional: true
  has_many :enrollments, dependent: :destroy
  has_many :school_classes, through: :enrollments
  has_many :responses, dependent: :destroy
  has_many :teachings, dependent: :destroy, class_name: "Enrollment", foreign_key: "teacher_id"
  has_many :teaching_classes, through: :teachings, source: :school_class
  has_many :enrolled_classes, through: :enrollments, source: :school_class

  # Validações
  validates :name, presence: true
  validates :registration_number, uniqueness: true
  validates :role, presence: true

  # Enum de roles
  enum :role, { student: 0, teacher: 1, admin: 2 }, default: :student

  # Método para retornar todas as classes associadas ao usuário, dependendo do seu papel (professor ou aluno)
  def all_classes
    if teacher?
      teaching_classes
    else
      school_classes
    end
  end
end
