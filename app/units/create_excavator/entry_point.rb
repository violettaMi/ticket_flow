module CreateExcavator
  class EntryPoint
    def self.call(ticket_id:, excavator_params:)
      new(ticket_id: ticket_id, excavator_params: excavator_params).call
    end

    def initialize(ticket_id:, excavator_params:)
      @ticket_id = ticket_id
      @form = Forms::Excavator.new(excavator_params)
    end

    def call
      form.validate!

      Excavator.create!(form.attributes.merge(ticket_id: ticket_id))
    end

    private

    attr_reader :ticket_id, :form
  end
end
