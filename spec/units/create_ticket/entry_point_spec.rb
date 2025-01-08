require 'rails_helper'

RSpec.describe CreateTicket::EntryPoint, type: :service do
  describe '.call' do
    let(:valid_params) do
      {
        request_number: "12345",
        sequence_number: 1,
        request_type: "Normal",
        response_time: Time.zone.now,
        primary_service_area_code: "ZZGL103",
        additional_service_area_codes: [ "ZZL01", "ZZL02" ],
        dig_site_info: "POLYGON((-81.13390268 32.07206917))"
      }
    end

    context 'with valid params' do
      it 'creates a ticket' do
        expect do
          ticket = described_class.call(params: valid_params)
          expect(ticket).to be_persisted
          expect(ticket.request_number).to eq("12345")
          expect(ticket.sequence_number).to eq(1)
          expect(ticket.request_type).to eq("Normal")
          expect(ticket.primary_service_area_code).to eq("ZZGL103")
          expect(ticket.additional_service_area_codes).to eq([ "ZZL01", "ZZL02" ])
          expect(ticket.dig_site_info).to eq("POLYGON((-81.13390268 32.07206917))")
        end.to change(Ticket, :count).by(1)
      end
    end

    context 'with invalid params' do
      it 'raises a validation error' do
        invalid_params = valid_params.merge(request_number: nil)
        expect { described_class.call(params: invalid_params) }.to raise_error(ActiveModel::ValidationError)
      end
    end
  end
end
