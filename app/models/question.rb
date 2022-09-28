# == Schema Information
#
# Table name: questions
#
#  id         :bigint           not null, primary key
#  content    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Question < ApplicationRecord
  # Associations
  has_and_belongs_to_many :templates
  has_many :answers

  has_many :template_questions
  # has_many :templates, through: :template_questions

  # Validations
  validates :content, presence: true, uniqueness: true
end
