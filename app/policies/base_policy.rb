class BasePolicy
  attr_accessor :user

  def initialize(user:)
    @user = user
  end

  def loudly
    raise ArgumentError unless block_given?
    return true if yield

    raise PolicyException
  end

  private

  def is_admin?
    user.has_role?(:admin)
  end

  def is_teacher?
    user.has_role?(:teacher)
  end

  def is_student?
    user.has_role?(:student)
  end
end