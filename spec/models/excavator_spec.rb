require 'rails_helper'

RSpec.describe Excavator, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:ticket) }
  end
end
