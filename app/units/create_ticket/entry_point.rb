module CreateTicket
  class EntryPoint
    def self.call(ticket_params:, excavator_params:)
      new(ticket_params: ticket_params, excavator_params: excavator_params).call
    end

    def initialize(ticket_params:, excavator_params:)
      @ticket_form = Forms::Ticket.new(ticket_params)
      @excavator_form = Forms::Excavator.new(excavator_params)
    end

    def call
      ActiveRecord::Base.transaction do # TODO: move to controller layer
        ticket_form.validate!
        excavator_form.validate!

        ticket = Ticket.create!(ticket_form.attributes)
        CreateExcavator::EntryPoint.call(ticket_id: ticket.id, excavator_params: excavator_form.attributes)
      end
    end

    private

    attr_reader :ticket_form, :excavator_form
  end
end
