# == Schema Information
#
# Table name: templates
#
#  id         :bigint           not null, primary key
#  code       :string
#  name       :string
#  state      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TemplateSerializer < ActiveModel::Serializer
  attributes :id, :code, :name, :state

  has_many :template_questions

  # Algorithm if it is necessary to return the template already ordered ready to paint 👇
  # This replaces the "has_many" association from "template_questions"

  # def categories
  #   %w[
  #     domain
  #     methodology
  #     relationship
  #     puntuality
  #     contents
  #     dedication
  #     discipline
  #   ].each_with_object([]) do |item, array|
  #     category = Hash.new
  #     category[:name] = item
  #     category[:questions] = questions_list(category[:name])
  #     array << category
  #   end
  # end

  # private

  # def questions_list(category_name)
  #   object.template_questions.where(category: category_name).reduce([]) do |arr, tq| 
  #     arr << { id: tq.question.id, content: tq.question.content }
  #   end
  # end

end
