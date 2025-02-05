class Department < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
  has_many :subjects, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
end
