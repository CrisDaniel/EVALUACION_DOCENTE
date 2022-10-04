class BaseService
  attr_accessor :user, :data

  def initialize(user: nil, data: nil)
    @user = user
    @data = data || {}
  end
end