# == Schema Information
#
# Table name: template_questions
#
#  id          :bigint           not null, primary key
#  template_id :bigint           not null
#  question_id :bigint           not null
#  order       :integer          default(0)
#  category    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class TemplateQuestion < ApplicationRecord
  # Associations
  belongs_to :template
  belongs_to :question

  # Validations
  validates :template, uniqueness: { scope: :question, message: "and Question combination already taken" }
  validates :order, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :category, presence: true

  enum category: {
    domain: 1,        # Dominio del profesor sobre el curso
    methodology: 2,   # Metodos de ensañanza
    relationship: 3,  # Relación del profesor con los estudiantes
    puntuality: 4,    # Puntualidad y cumplimiento
    contents: 5,      # Contenido del curso para la formación profesional
    dedication: 6,    # Esfuerzo y dedicación
    discipline: 7     # Mantenimiento de la disciplina en clase
  }    
end
