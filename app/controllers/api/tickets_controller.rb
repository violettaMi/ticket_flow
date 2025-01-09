module Api
  class TicketsController < ApplicationController
    protect_from_forgery with: :null_session

    def create
      ticket = ActiveRecord::Base.transaction do
        CreateTicket::EntryPoint.call(ticket_params: mapped_ticket_params, excavator_params: mapped_excavator_params)
      end

      render json: { ticket_id: ticket.id }, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { errors: [ e.message ] }, status: :bad_request
    end

    private

    def mapped_ticket_params
      {
        request_number: dig_param(:RequestNumber),
        sequence_number: dig_param(:SequenceNumber),
        request_type: dig_param(:RequestType),
        response_time: params.dig(:DateTimes, :ResponseDueDateTime),
        primary_service_area_code: params.dig(:ServiceArea, :PrimaryServiceAreaCode, :SACode),
        additional_service_area_codes: Array(params.dig(:ServiceArea, :AdditionalServiceAreaCodes, :SACode)),
        dig_site_info: params.dig(:DigsiteInfo, :WellKnownText)
      }
    end

    def mapped_excavator_params
      {
        company_name: params.dig(:Excavator, :CompanyName),
        address: full_address,
        crew_on_site: to_boolean(params.dig(:Excavator, :CrewOnsite))
      }
    end

    def full_address
      [
        params.dig(:Excavator, :Address),
        params.dig(:Excavator, :City),
        params.dig(:Excavator, :State),
        params.dig(:Excavator, :Zip)
      ].compact.join(", ")
    end

    def to_boolean(value)
      ActiveModel::Type::Boolean.new.cast(value)
    end

    def dig_param(key)
      params[key].presence
    end
  end
end
