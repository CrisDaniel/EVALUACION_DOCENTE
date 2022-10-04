# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  fullname               :string
#  code                   :integer
#
class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :code,
             :fullname, 
             :email,
             :role
  
  has_many :courses

  def role
     object.roles.first.name || ''
  end
end
