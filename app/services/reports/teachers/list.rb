class Reports::Teachers::List < BaseService
  include TeachersFilters

  def initialize(teachers:, data:)
    @teachers = teachers
    @data = data
  end
  
  def call
    teachers_group = group_list
    teachers_group = search(teachers_group, data)
    teachers_group = list(teachers_group)
    teachers_group = pagination(teachers_group)

    {
      success: true,
      data: {
        per_page: 6,
        total_pages: teachers_group.total_pages,
        total_objects: teachers_group.total_count,
        current_page: (data[:page] || 1).to_i,
        teachers: json_teacher(teachers_group)
      },
      message: "Reporte de Docentes."
    }
  end

  private

  def pagination(teachers)
    teachers.page(data[:page] || 1).per(6)
  end

  def json_teacher(teachers)
    teachers.map do |teacher|
      surveys = teacher.teacher_surveys
      completed_survey = surveys.where(state: "completed").size
      incompleted_survey = surveys.where(state: "incompleted").size

      {
        id: teacher.id,
        code: teacher.code,
        fullname: teacher.fullname,
        email: teacher.email,
        surveys: {
          completed: completed_survey,
          incompleted: incompleted_survey
        },
        categories: categories(surveys)
      }
    end
  end

  def categories(surveys)
    answers = surveys.each_with_object([]){ |survey, array| array << survey.answers }.flatten

    categories = answers.each_with_object({}) do |answer, avg|
      category = answer.question.template_questions.find_by(template_id: answer.survey.template_id).category      
      unless avg.has_key?(category.to_sym)
        avg[category.to_sym] = []
      end

      avg[category.to_sym] << answer.point
    end
    
    categories = {
      domain: avg_category(categories[:domain]),
      methodology: avg_category(categories[:methodology]),
      relationship: avg_category(categories[:relationship]),
      puntuality: avg_category(categories[:puntuality]),
      contents: avg_category(categories[:contents]),
      dedication: avg_category(categories[:dedication]),
      discipline: avg_category(categories[:discipline]),
    }
  end

  def avg_category(category_points)
    return 0.0 unless category_points.present?

    category_points.reduce(:+).fdiv(category_points.size).round(1)
  end

end