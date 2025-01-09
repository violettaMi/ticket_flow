require 'rails_helper'

RSpec.describe CreateTicket::EntryPoint do
  subject(:entry_point) do
    described_class.new(ticket_params: ticket_params, excavator_params: excavator_params)
  end

  let(:ticket_params) do
    {
      request_number: '12345',
      sequence_number: 1,
      request_type: 'Normal',
      response_time: Time.zone.now,
      primary_service_area_code: 'ZZGL103',
      additional_service_area_codes: [ 'ZZL01', 'ZZL02' ],
      dig_site_info: 'POLYGON((-81.13390268 32.07206917))'
    }
  end

  let(:excavator_params) do
    {
      company_name: 'ABC Excavators',
      address: '123 Main St',
      crew_on_site: true
    }
  end

  describe '.call' do
    context 'when ticket params are invalid' do
      context 'when request_number is nil' do
        let(:ticket_params) { { request_number: nil } }

        it 'raises a validation error and does not create any records' do
          expect { entry_point.call }.to raise_error(ActiveModel::ValidationError)
          expect(Ticket.count).to eq(0)
          expect(Excavator.count).to eq(0)
        end
      end

      context 'when sequence_number is negative' do
        let(:ticket_params) { { request_number: '12345', sequence_number: -1, request_type: 'Normal' } }

        it 'raises a validation error and does not create any records' do
          expect { entry_point.call }.to raise_error(ActiveModel::ValidationError)
          expect(Ticket.count).to eq(0)
          expect(Excavator.count).to eq(0)
        end
      end
    end

    context 'when params are valid' do
      it 'creates a ticket' do
        expect { entry_point.call }.to change(Ticket, :count).from(0).to(1)

        ticket = Ticket.last

        expect(ticket).to have_attributes(
          request_number: '12345',
          sequence_number: 1,
          request_type: 'Normal',
          primary_service_area_code: 'ZZGL103',
          additional_service_area_codes: [ 'ZZL01', 'ZZL02' ]
        )
      end
    end
  end
end
