module TemplatesFilters
  extend ActiveSupport::Concern

  private

  def group_list
    Template.all
  end

  def search(templates)
    return templates unless data.dig(:q).present?

    templates.where("
      lower(name) LIKE ? OR lower(code) LIKE ?",
      "%#{data.dig(:q).downcase}%",
      "%#{data.dig(:q).downcase}%"
    )
  end

  def list(templates)
    return [] unless templates.present?

    return templates.order("name ASC") unless data.dig(:order_by).present?
    
    templates.order("name #{data.dig(:order_by)}")
  end
end