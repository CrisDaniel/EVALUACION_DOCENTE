# == Schema Information
#
# Table name: surveys
#
#  id          :bigint           not null, primary key
#  template_id :bigint           not null
#  student_id  :integer          not null
#  teacher_id  :integer          not null
#  course_id   :bigint           not null
#  state       :integer          default("incompleted")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Survey < ApplicationRecord
  # Associations
  belongs_to :template
  belongs_to :student, class_name: 'User'
  belongs_to :teacher, class_name: 'User'
  belongs_to :course

  has_many :answers

  # Validates
  validates :template, uniqueness: { 
    scope: [:student, :teacher, :course],
    message: "and combination to [student, teacher, course] already taken"
  }

  enum state: {
    incompleted: 0,
    completed: 1
  }

  scope :all_published, -> { joins(:template).where("templates.state = 1") }
end
