class CreateSurveyAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :survey_answers do |t|
      t.belongs_to :survey, null: false, foreign_key: true
      t.belongs_to :member, null: false, foreign_key: true
      t.belongs_to :cclass, null: false, foreign_key: true

      t.timestamps
    end
  end
end
