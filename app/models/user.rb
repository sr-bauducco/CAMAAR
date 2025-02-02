class User < ApplicationRecord
  self.primary_key = "user_id" # Define 'user_id' como chave primária

  has_secure_password

  validates :user_id, presence: true, uniqueness: true
  validates :enrollment, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :role, presence: true, inclusion: { in: %w[admin user] } # Define roles possíveis
end
