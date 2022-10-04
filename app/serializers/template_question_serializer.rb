class TemplateQuestionSerializer < ActiveModel::Serializer
  attributes :id, :order, :category, :question

  def question
    QuestionSerializer.new(object.question)
  end
end