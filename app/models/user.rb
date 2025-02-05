class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :department
  has_many :enrollments, dependent: :destroy
  has_many :school_classes, through: :enrollments
  has_many :responses, dependent: :destroy
  has_many :teachings, dependent: :destroy, class_name: "Enrollment", foreign_key: "teacher_id"
  has_many :teaching_classes, through: :teachings, source: :school_class
  has_many :enrolled_classes, through: :enrollments, source: :school_class

  validates :name, presence: true
  validates :registration_number, presence: true, uniqueness: true
  validates :role, presence: true

  enum :role, { student: 0, teacher: 1, admin: 2 }, default: :student

  def all_classes
    if teacher?
      teaching_classes
    else
      school_classes
    end
  end
end
