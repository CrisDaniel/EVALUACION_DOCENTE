class Courses::Create < BaseService
  attr_accessor :data

  def initialize(data:)
    super(data: data)

    @data = data
  end

  def call
    return message_json(false, {}, "bad_request", "No tiene un codigo del curso") unless has_code?

    course = Course.new(@data)

    if course.save
      return message_json(true, course, "ok", "Se agrego el curso con exito!")
    end

    message_json(false, {}, "bad_request", course.errors.full_messages.join(', '))
  end

  private

  def has_code?
    return false unless data[:code].present?

    true
  end

  def message_json(success, data, code, message)
    {
      success: success,
      data: data,
      code: code,
      message: message
    }
  end
end