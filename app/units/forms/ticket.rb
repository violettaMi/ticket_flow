module Forms
  class Ticket
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    attribute :request_number, :string
    attribute :sequence_number, :integer
    attribute :request_type, :string
    attribute :response_time, :datetime
    attribute :primary_service_area_code, :string
    attribute :additional_service_area_codes, array: :string
    attribute :dig_site_info, :string

    validates :request_number, presence: true, length: { maximum: 255 }
    validates :sequence_number, presence: true, numericality: { only_integer: true }
    validates :request_type, presence: true, length: { maximum: 255 }
    validates :response_time, presence: true
    validates :primary_service_area_code, presence: true, length: { maximum: 255 }
    validates :additional_service_area_codes, presence: true
    validates :dig_site_info, presence: true
  end
end
