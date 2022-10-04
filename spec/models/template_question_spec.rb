# == Schema Information
#
# Table name: template_questions
#
#  id          :bigint           not null, primary key
#  template_id :bigint           not null
#  question_id :bigint           not null
#  order       :integer          default(0)
#  category    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe TemplateQuestion, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end if false
