module TeachersFilters
    extend ActiveSupport::Concern
  
    private
  
    def group_list
      User.all_teachers
    end
  
    def search(teachers, data)
    #   raise
      return teachers unless data.dig(:q).present?
  
      teachers.where("
        lower(fullname) LIKE ?
        OR lower(email) LIKE ?",
        "%#{data.dig(:q).downcase}%",
        "%#{data.dig(:q).downcase}%"
      )
    end
  
    def list(teachers)
      return [] unless teachers.present?
  
      return teachers.order("fullname ASC") unless data.dig(:order_by).present?
  
      teachers.order("fullname #{data.dig(:order_by)}")
    end
    # TODO: pendiente a ordenar por encuestas completadas.  
  end