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
require 'rails_helper'

RSpec.describe Template, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end if false
