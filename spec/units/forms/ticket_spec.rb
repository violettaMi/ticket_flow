require 'rails_helper'

RSpec.describe Forms::Ticket, type: :model do
  subject(:form) do
    described_class.new(
      request_number: "12345",
      sequence_number: 1,
      request_type: "Normal",
      response_time: Time.zone.now,
      primary_service_area_code: "ZZGL103",
      additional_service_area_codes: [ "ZZL01", "ZZL02" ],
      dig_site_info: "POLYGON((-81.13390268 32.07206917))"
    )
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:request_number) }
    it { is_expected.to validate_presence_of(:sequence_number) }
    it { is_expected.to validate_presence_of(:response_time) }
    it { is_expected.to validate_presence_of(:primary_service_area_code) }
    it { is_expected.to validate_presence_of(:dig_site_info) }
  end
end
