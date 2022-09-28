class Courses::List < BaseService
  include ::CoursesFilters

  attr_accessor :courses, :data

  def initialize(courses:, data:)
    @courses = courses
    @data = data
  end

  def call
    courses_group = group_list
    courses_group = search(courses_group)
    courses_group = pagination(courses_group)

    {
      success: true,
      data: {
        per_page: 6,
        total_pages: courses_group.total_pages,
        total_objects: courses_group.total_count,
        current_page: (data[:page] || 1).to_i,
        courses: serializer(courses_group)
      },
      message: "Lista de Cursos!!"
    }
  end

  private

  def pagination(courses)
    courses.page(data[:page] || 1).per(6)
  end

  def serializer(courses)
    ActiveModelSerializers::SerializableResource.new(
      list(courses),
      each_serializer: ::CourseSerializer
    )
  end

end