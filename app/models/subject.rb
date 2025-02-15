class Subject < ApplicationRecord
  # Associações
  belongs_to :department
  has_many :school_classes, dependent: :restrict_with_error

  # Validações
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
end
