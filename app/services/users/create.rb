class Users::Create < BaseService
  attr_accessor :data

  def initialize(data:)
    super(data: data)

    @data = data
  end

  def call
    return message_json(false, "bad_request", 'No tiene un role seleccionado') unless has_role?
    return message_json(false, "bad_request", 'Agregue un email') unless has_email?
    return message_json(false, "bad_request", 'Agregue un Código de usuario') unless has_code?

    user = User.new(allowed_params)

    if user.save && user.add_role(role.name)
      
      return message_json(true, "ok", "Se creo el usuario con exito!")
    end

    message_json(false, 'bad_request', user.errors.full_messages.join(', '))
  end

  private

  def has_role?
    return false unless role.present?

    true
  end

  def has_email?
    return false unless @data[:email].present?

    true
  end

  def has_code?
    return false unless @data[:code].present?

    true
  end

  def role
    @role ||= Role.find_by(name: @data[:role_name])
  end

  def message_json(success, code, message)
    {
      success: success,
      code: code,
      message: message
    }
  end

  def allowed_params
    @data.delete(:role_name)
    @data[:course_ids].uniq! if @data.include?(:course_ids)
    @data[:password] = @data[:code]
    @data
  end
end