class Students::List < BaseService
  include ::StudentsFilters

  attr_accessor :students, :data

  def initialize(students:, data:)
    @students = students
    @data = data
  end

  def call
    students_group = group_list
    students_group = search(students_group)
    students_group = pagination(students_group)

    {
      success: true,
      data: {
        per_page: 6,
        total_pages: students_group.total_pages,
        total_objects: students_group.total_count,
        current_page: (data[:page] || 1).to_i,
        students: serializer(students_group)
      },
      message: "Lista de estudiantes!!"
    }
  end

  private

  def pagination(students)
    students.page(data[:page] || 1).per(6)
  end

  def serializer(students)
    ActiveModelSerializers::SerializableResource.new(
      list(students),
      each_serializer: ::UserSerializer
    )
  end

end