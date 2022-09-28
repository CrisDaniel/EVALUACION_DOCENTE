# == Schema Information
#
# Table name: templates
#
#  id         :bigint           not null, primary key
#  code       :string
#  name       :string
#  state      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Template < ApplicationRecord
  # Associations
  has_many :template_questions, dependent: :destroy
  has_many :questions, through: :template_questions

  has_many :surveys

  # Validations
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true

  # Callbacks
  after_update :change_state

  enum state: {
    draft: 0,
    published: 1,
    archived: 2
  }

  scope :all_draft, -> { draft }
  scope :all_published, -> { published }
  scope :all_archived, -> { archived }

  private

  def change_state
    if(self.published?)
      # Clear all templates, because only one published template can exist
      temp_template = Template.all_published.where.not(id: self.id)
      temp_template.update_all state: "archived"
      
      # Generate surveys to new template published
      Course.all.each do |course|
        all_teacher_courses = course.users.all_teachers
    
        course.users.all_students.each do |student|
          all_teacher_courses.each do |teacher|
            Survey.find_or_create_by(
              template: self,
              student: student,
              teacher: teacher,
              course: course
            )
          end
        end
      end
    end
  end

end
