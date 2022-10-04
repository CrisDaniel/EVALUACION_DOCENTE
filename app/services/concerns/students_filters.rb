module StudentsFilters
  extend ActiveSupport::Concern

  private

  def group_list
    User.all_students
  end

  def search(students)
    return students unless data.dig(:q).present?

    students.where("
      lower(fullname) LIKE ?
      OR lower(email) LIKE ?",
      "%#{data.dig(:q).downcase}%",
      "%#{data.dig(:q).downcase}%"
    )
  end

  def list(students)
    return [] unless students.present?

    return students.order("fullname ASC") unless data.dig(:order_by).present?

    students.order("fullname #{data.dig(:order_by)}")
  end

end