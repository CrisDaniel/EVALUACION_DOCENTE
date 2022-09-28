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
class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, 
          :registerable,
          :recoverable, 
          :rememberable, 
          :validatable,
          :jwt_authenticatable, 
          jwt_revocation_strategy: JwtDenylist

  has_and_belongs_to_many :courses

  has_many :student_surveys, class_name: 'Survey', 
                            foreign_key: 'student_id'
  has_many :teacher_surveys, class_name: 'Survey',
                            foreign_key: 'teacher_id'

  scope :all_students, -> { includes(:roles).where("roles.name = 'student'").references(:roles) }
  scope :all_teachers, -> { includes(:roles).where("roles.name = 'teacher'").references(:roles) }
  scope :without_admins, -> { includes(:roles).where.not("roles.name = 'admin'").references(:roles) }
end
