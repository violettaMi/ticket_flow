require 'rails_helper'

RSpec.describe Forms::Excavator, type: :model do
  subject(:form) do
    described_class.new(
      company_name: "ABC Excavators",
      address: "123 Main St",
      crew_on_site: true
    )
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:company_name) }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_inclusion_of(:crew_on_site).in_array([ true, false ]) }
    it { is_expected.to validate_length_of(:company_name).is_at_most(255) }
    it { is_expected.to validate_length_of(:address).is_at_most(255) }
  end
end
