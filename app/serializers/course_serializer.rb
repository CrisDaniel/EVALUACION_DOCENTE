# == Schema Information
#
# Table name: courses
#
#  id         :bigint           not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class CourseSerializer < ActiveModel::Serializer
  attributes :id, :code, :name, :teacher

  def teacher
    object.users.find{ |user| user.has_role? :teacher }&.fullname
  end
end
