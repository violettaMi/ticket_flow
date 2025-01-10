ticket = Ticket.create!(
  request_number: '12345',
  sequence_number: 1,
  request_type: 'Normal',
  response_time: Time.now + 2.days,
  primary_service_area_code: 'AREA123',
  additional_service_area_codes: [ 'AREA456', 'AREA789' ],
  dig_site_info: "POLYGON((-81.13390268058475 32.07206917625161,-81.14660562247929 32.04064386441295,-81.08858407706913 32.02259853170128,-81.05322183341679 32.02434500961698,-81.05047525138554 32.042681017283066,-81.0319358226746 32.06537765335268,-81.01202310294804 32.078469305179404,-81.02850259513554 32.07963291684719,-81.07759774894413 32.07090546831167,-81.12154306144413 32.08806865844325,-81.13390268058475 32.07206917625161))"
)

Excavator.create!(
  ticket_id: ticket.id,
  company_name: 'Example Excavator Co.',
  address: '123 Main Street',
  crew_on_site: true
)

ticket_two = Ticket.create!(
  request_number: '123',
  sequence_number: 2,
  request_type: 'Urgent',
  response_time: Time.now + 1.days,
  primary_service_area_code: 'AC123',
  additional_service_area_codes: [ 'AC456', 'AC789' ],
  dig_site_info: "POLYGON((30.1 10.1, 40.2 40.2, 20.3 40.3, 10.4 20.4, 30.1 10.1))"
)

Excavator.create!(
  ticket_id: ticket_two.id,
  company_name: 'Excavator Co.',
  address: '123 Main Street, zip 12345, UK',
  crew_on_site: false
)
