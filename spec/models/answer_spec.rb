# == Schema Information
#
# Table name: answers
#
#  id          :bigint           not null, primary key
#  survey_id   :bigint           not null
#  question_id :bigint           not null
#  point       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Answer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end if false
