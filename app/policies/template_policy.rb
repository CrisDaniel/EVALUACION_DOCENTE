class TemplatePolicy < BasePolicy
  def initialize(user:)
    super(user: user)
  end

  def can_read?
    loudly do
      is_admin?
    end
  end

  def can_write?
    loudly do
      is_admin?
    end
  end
end