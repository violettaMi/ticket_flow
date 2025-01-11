require 'rails_helper'

RSpec.describe 'Api::TicketsController', type: :request do
  let(:valid_params) do
    {
      RequestNumber: '123456',
      SequenceNumber: '1',
      RequestType: 'Normal',
      DateTimes: {
        ResponseDueDateTime: '2025-01-11T12:00:00Z'
      },
      ServiceArea: {
        PrimaryServiceAreaCode: { SACode: 'ZZGL103' },
        AdditionalServiceAreaCodes: { SACode: [ 'ZZL01', 'ZZL02' ] }
      },
      DigsiteInfo: {
        WellKnownText: 'POLYGON((-81.13390268058475 32.07206917625161, -81.14660562247929 32.04064386441295))'
      },
      Excavator: {
        CompanyName: 'John Doe Construction',
        Address: '123 Main St',
        City: 'Savannah',
        State: 'GA',
        Zip: '31401',
        CrewOnsite: 'true'
      }
    }
  end

  describe 'POST /api/tickets' do
    context 'with valid parameters' do
      it 'creates a ticket and returns ticket_id' do
        post '/api/tickets', params: valid_params, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json).to include('ticket_id')
      end
    end

    context 'with missing required fields' do
      it 'returns errors for missing RequestNumber' do
        invalid_params = valid_params.except(:RequestNumber)

        post '/api/tickets', params: invalid_params, as: :json

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['errors']).to include("Validation failed: Request number can't be blank")
      end
    end

    context 'with invalid AdditionalServiceAreaCodes' do
      it 'handles empty AdditionalServiceAreaCodes gracefully' do
        params = valid_params.deep_merge({
          ServiceArea: { AdditionalServiceAreaCodes: { SACode: [] } }
        })

        post '/api/tickets', params: params, as: :json

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['errors']).to include("Validation failed: Additional service area codes can't be blank")
      end

      it 'handles missing AdditionalServiceAreaCodes gracefully' do
        params = valid_params.deep_merge({
          ServiceArea: { AdditionalServiceAreaCodes: nil }
        })

        post '/api/tickets', params: params, as: :json

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['errors']).to include("Validation failed: Additional service area codes can't be blank")
      end
    end

    context 'when an unexpected error occurs' do
      before do
        allow(CreateTicket::EntryPoint).to receive(:call).and_raise(StandardError, 'Something went wrong')
      end

      it 'returns a 400 Bad Request with the error message' do
        post '/api/tickets', params: valid_params, as: :json

        expect(response).to have_http_status(:bad_request)
        json = JSON.parse(response.body)
        expect(json['errors']).to include('Something went wrong')
      end
    end
  end
end
