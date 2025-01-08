module CreateTicket
  class EntryPoint
    def self.call(params:)
      new(params: params).call
    end

    attr_reader :form

    def initialize(params:)
      @form = Forms::Ticket.new(params)
    end

    def call
      form.validate!

      Ticket.create!(form.attributes)
    end
  end
end
