# == Schema Information
#
# Table name: surveys
#
#  id          :bigint           not null, primary key
#  template_id :bigint           not null
#  student_id  :integer          not null
#  teacher_id  :integer          not null
#  course_id   :bigint           not null
#  state       :integer          default("incompleted")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Survey, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end if false
