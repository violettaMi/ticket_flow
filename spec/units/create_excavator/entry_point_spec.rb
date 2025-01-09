require 'rails_helper'

RSpec.describe CreateExcavator::EntryPoint do
  subject(:entry_point) { described_class.new(ticket_id: ticket.id, excavator_params: excavator_params) }

  let(:ticket) { create(:ticket) }
  let(:excavator_params) do
    {
      company_name: 'ABC Excavators',
      address: '123 Main St',
      crew_on_site: true
    }
  end

  describe '.call' do
    context 'when params are invalid' do
      let(:excavator_params) { { company_name: nil, address: '123 Main St', crew_on_site: true } }

      it 'raises a validation error and does not create an excavator' do
        expect { entry_point.call }.to raise_error(ActiveModel::ValidationError)
        expect(Excavator.count).to eq(0)
      end
    end

    context 'when params are valid' do
      it 'creates an excavator' do
        expect { entry_point.call }.to change(Excavator, :count).from(0).to(1)

        excavator = Excavator.last

        expect(excavator).to have_attributes(
          company_name: 'ABC Excavators',
          address: '123 Main St',
          crew_on_site: true,
          ticket_id: ticket.id
        )
      end
    end
  end
end
