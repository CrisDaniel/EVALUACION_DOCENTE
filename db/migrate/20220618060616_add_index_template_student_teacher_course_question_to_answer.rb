class AddIndexTemplateStudentTeacherCourseQuestionToAnswer < ActiveRecord::Migration[6.0]
  def change
    add_index :surveys, 
      [:template_id, :student_id, :teacher_id, :course_id], 
      unique: true,
      name: :index_template_student_teacher_course
  end
end
