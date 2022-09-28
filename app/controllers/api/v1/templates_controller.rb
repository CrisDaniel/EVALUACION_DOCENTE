class Api::V1::TemplatesController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  # GET /api/v1/templates?q=search&order_by=ASC&page=number_page
  def index
    policy.can_read?

    service = Templates::List.new(templates: Template.all, data: params)
    render json: service.call, status: :ok
  end

  # GET /api/v1/templates/:template_id
  def show
    policy.can_read?

    template = Template.find_by!(id: params[:template_id])
    render json: { success: true, template: TemplateSerializer.new(template), message: "Curso encontrado"}, status: :ok
  end

  # POST /api/v1/templates
  def create
    policy.can_write?

    service = Templates::Create.new(data: allowed_params)
    render json: service.call, status: :ok
  end

  # PATCH /api/v1/templates/:template_id
  def update
    policy.can_write?

    service = Templates::Update.new(template_id: params[:template_id], data: allowed_params)
    render json: service.call, status: :ok
  end

  # DELETE /api/v1/templates/:template_id
  def destroy
    policy.can_write?

    template = Template.all_draft.find_by!(id: params[:template_id])
    template.destroy!
    render json: { success: true, message: "Se retiro el template con exito!"}, status: :ok
  end

  # POST /api/v1/templates/:template_id/clone
  def clone
    policy.can_write?

    template = Template.find_by!(id: params[:template_id])
    service = Templates::Clone.new(template: template)
    render json: service.call, status: :ok
  end

  private

  def policy
    TemplatePolicy.new(user: current_user)
  end

  def allowed_params
    params.require(:template).permit(
      :code, 
      :name,
      :state,
      template_questions: [
        :id, 
        :order, 
        :category, 
        question: [
          :id, 
          :content
        ]
      ]
    )
  end

end
