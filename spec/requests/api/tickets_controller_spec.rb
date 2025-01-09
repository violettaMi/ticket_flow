require 'rails_helper'

RSpec.describe 'Api::TicketsController', type: :request do
  describe 'POST /api/tickets' do
    let(:valid_params) do
      {
        RequestNumber: '09252012-00001',
        SequenceNumber: '2421',
        RequestType: 'Normal',
        DateTimes: {
          ResponseDueDateTime: '2011/07/13 23:59:59'
        },
        ServiceArea: {
          PrimaryServiceAreaCode: { SACode: 'ZZGL103' },
          AdditionalServiceAreaCodes: { SACode: %w[ZZL01 ZZL02 ZZL03] }
        },
        Excavator: {
          CompanyName: 'John Doe CONSTRUCTION',
          Address: '555 Some RD',
          City: 'SOME PARK',
          State: 'ZZ',
          Zip: '55555',
          CrewOnsite: 'true'
        },
        DigsiteInfo: {
          WellKnownText: 'POLYGON((-81.13390268 32.07206917))'
        }
      }
    end

    let(:headers) { { 'Content-Type' => 'application/json' } }

    it 'creates a new ticket and excavator' do
      expect do
        post '/api/tickets', params: valid_params, as: :json
      end.to change(Ticket, :count).by(1)
        .and change(Excavator, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    # it 'returns errors if invalid' do
    #   invalid_params = valid_params.merge(RequestNumber: nil)

    #   post '/api/tickets', params: invalid_params, as: :json

    #   expect(response).to have_http_status(:unprocessable_entity)
    #   expect(JSON.parse(response.body)['errors']).to include("Request number can't be blank")
    # end
  end
end
