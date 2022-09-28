class Teachers::List < BaseService
  include TeachersFilters

  attr_accessor :teachers, :data

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
        teachers: serializer(teachers_group)
      },
      message: "Lista de estudiantes!!"
    }
  end

  private

  def pagination(teachers)
    teachers.page(data[:page] || 1).per(6)
  end

  def serializer(teachers)
    ActiveModelSerializers::SerializableResource.new(
      teachers,
      each_serializer: ::UserSerializer
    )
  end

end
