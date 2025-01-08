require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe 'associations' do
    it { is_expected.to have_one(:excavator).dependent(:destroy) }
  end
end
