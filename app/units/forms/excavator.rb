module Forms
  class Excavator
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    attribute :company_name, :string
    attribute :address, :string
    attribute :crew_on_site, :boolean, default: false

    validates :company_name, presence: true, length: { maximum: 255 }
    validates :address, presence: true, length: { maximum: 255 }
    validates :crew_on_site, inclusion: { in: [ true, false ] }
  end
end
