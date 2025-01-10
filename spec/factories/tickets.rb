FactoryBot.define do
  factory :ticket do
    request_number { '09252012-00001' }
    sequence_number { 2421 }
    request_type { 'Normal' }
    response_time { '2011-07-13 23:59:59' }
    primary_service_area_code { 'ZZGL103' }
    additional_service_area_codes { %w[ZZL01 ZZL02] }
    dig_site_info { "POLYGON((30.1 10.1, 40.2 40.2, 20.3 40.3, 10.4 20.4, 30.1 10.1))" }
  end
end
