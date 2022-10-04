module CoursesFilters
  extend ActiveSupport::Concern

  private

  def group_list
    Course.all
  end

  def search(courses)
    return courses unless data.dig(:q).present?

    courses.where("
      lower(name) LIKE ?",
      "%#{data.dig(:q).downcase}%"
    )
  end

  def list(courses)
    return [] unless courses.present?

    return courses.order("name ASC") unless data.dig(:order_by).present?

    courses.order("name #{data.dig(:order_by)}")
  end

end