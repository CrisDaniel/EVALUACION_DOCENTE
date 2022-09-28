# == Schema Information
#
# Table name: answers
#
#  id          :bigint           not null, primary key
#  survey_id   :bigint           not null
#  question_id :bigint           not null
#  point       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Answer < ApplicationRecord
  # Associations
  belongs_to :survey
  belongs_to :question

  # Validations
  validates :survey, uniqueness: { scope: :question, message: "and Question combination already taken" }
  validates :point, presence: true, inclusion: { in: 1..5 }

  # Callbacks
  after_create :survey_completed?
  after_update :survey_completed?

  private

  def survey_completed?
    survey_questions_ids = survey.template.questions.ids
    answer_questions_ids = Answer.where(survey: survey).map(&:question_id)
    
    survey.completed! if survey_questions_ids.sort === answer_questions_ids.sort
  end
end
