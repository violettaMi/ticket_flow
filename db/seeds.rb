ticket = Ticket.create!(
  request_number: '12345',
  sequence_number: 1,
  request_type: 'Normal',
  response_time: Time.now + 2.days,
  primary_service_area_code: 'AREA123',
  additional_service_area_codes: [ 'AREA456', 'AREA789' ],
  dig_site_info: 'Sample dig site info'
)

Excavator.create!(
  ticket_id: ticket.id,
  company_name: 'Example Excavator Co.',
  address: '123 Main Street',
  crew_on_site: true
)
