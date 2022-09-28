class Templates::List < BaseService
  include ::TemplatesFilters

  attr_accessor :templates, :data

  def initialize(templates:, data:)
    super(data: data)

    @templates = templates
    @data = data
    
  end
  
  def call
    templates_group = group_list
    templates_group = search(templates_group)
    templates_group = pagination(templates_group)

    {
      success: true,
      data: {
        per_page: 6,
        total_pages: templates_group.total_pages,
        total_objects: templates_group.total_count,
        current_page: (data[:page] || 1).to_i,
        templates: serializer(templates_group)
      },
      message: "Template list"
    }
  end

  private

  def pagination(templates)
    templates.page(data[:page] || 1).per(6)
  end

  def serializer(templates)
    ActiveModelSerializers::SerializableResource.new(
      list(templates),
      each_serializer: ::TemplateSerializer
    )
  end

end