class SchoolClass < ApplicationRecord
  belongs_to :subject
  has_many :enrollments, dependent: :destroy
  has_many :users, through: :enrollments
  has_many :forms, dependent: :destroy

  validates :semester, presence: true
  validates :subject, presence: true

  def department
    subject.department
  end

  def name_with_subject
    "#{subject.name} - #{semester}"
  end

  def teachers
    User.joins(:teachings).where(enrollments: { school_class_id: id })
  end

  def students
    User.joins(:enrollments).where(enrollments: { school_class_id: id, teacher_id: nil })
  end
end
