class FormTemplate < ApplicationRecord
  belongs_to :department
  has_many :forms, dependent: :restrict_with_error

  validates :name, presence: true
  validates :questions, presence: true
  validates :department, presence: true
  validate :questions_format

  def questions_array
    questions.is_a?(String) ? JSON.parse(questions) : questions
  end

  private

  def questions_format
    return if questions.nil?

    begin
      questions_data = questions.is_a?(String) ? JSON.parse(questions) : questions
      unless questions_data.is_a?(Array)
        errors.add(:questions, "deve ser um array de questões")
        return
      end

      # Permite um array vazio de questões durante a criação
      return if questions_data.empty? && new_record?

      questions_data.each do |question|
        unless question.is_a?(Hash) && question["text"].present? && question["answer_type"].present?
          errors.add(:questions, "cada questão deve ter texto e tipo de resposta")
          return
        end

        unless [ "text", "number", "multiple_choice" ].include?(question["answer_type"])
          errors.add(:questions, "tipo de resposta inválido")
          return
        end
      end
    rescue JSON::ParserError
      errors.add(:questions, "formato inválido")
    end
  end
end
