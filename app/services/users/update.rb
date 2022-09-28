class Users::Update < BaseService
  attr_accessor :data

  def initialize(user_id:, data:)
    super(user: nil, data: data)

    @data = data
    @user_id = user_id
    @user = user
  end
  
  def call
    return message_json(false, 'not_found', 'No tiene seleccionado un usuario a editar') unless has_user?

    if @user.present?
      @data[:course_ids].uniq! if @data.include?(:course_ids)
      @user.update!(@data)
      return message_json(true, 'ok', 'Datos actualizados!')
    end


    message_json(false, 'not_found', 'Usuario no encontrado')
  end

  private

  def has_user?
    return false unless @user_id.present?

    true
  end

  def user
    @user ||= User.without_admins.find_by(id: @user_id)
  end

  def message_json(success, code, message)
    {
      success: success,
      code: code,
      message: message
    }
  end

end