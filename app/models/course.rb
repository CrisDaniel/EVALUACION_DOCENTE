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
class Course < ApplicationRecord
  # Associations
  has_and_belongs_to_many :users
  has_many :surveys

  # Validations
  validates :code, presence: true, uniqueness: true
end
