class Courses::Update < BaseService
  attr_accessor :data

  def initialize(course_id:, data:)
    super(data: data)

    @data = data
    @course_id = course_id
    @course = course
  end

  def call
    return message_json(false, 'not_found', 'No tiene curso a editar') unless has_course?

    if @course.present?
      @course.update!(@data)

      return message_json(true, 'ok', 'Datos actualizados!')
    end

    message_json(false, 'not_found', 'Curso no encontrado')
  end

  private

  def has_course?
    return false unless @course_id.present?

    true
  end

  def course
    @course ||= Course.find_by(id: @course_id)
  end

  def message_json(success, code, message)
    {
      success: success,
      code: code,
      message: message
    }
  end
end