class SurveySerializer < ActiveModel::Serializer
  attributes  :id,
              :teacher,
              :course,
              :state

  def teacher
    object.teacher.fullname
  end

  def course
    { 
      id: object.course_id,
      name: object.course.name
    }
  end

end