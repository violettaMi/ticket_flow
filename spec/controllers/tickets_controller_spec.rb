require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
  describe 'GET #index' do
    let!(:tickets) { create_list(:ticket, 3) }

    it 'assigns @tickets and renders the index template' do
      get :index

      expect(assigns(:tickets)).to match_array(tickets)
      expect(response).to render_template(:index)
    end

    it 'loads tickets in descending order of creation' do
      get :index

      expect(assigns(:tickets)).to eq(tickets.sort_by(&:created_at).reverse)
    end
  end

  describe 'GET #show' do
    let(:ticket) { create(:ticket) }
    let!(:excavator) { create(:excavator, ticket: ticket) }

    it 'assigns @ticket and @excavator' do
      get :show, params: { id: ticket.id }

      expect(assigns(:ticket)).to eq(ticket)
      expect(assigns(:ticket).excavator).to eq(excavator)
    end

    it 'renders the show template' do
      get :show, params: { id: ticket.id }
      expect(response).to render_template(:show)
    end

    it 'raises an ActiveRecord::RecordNotFound error if the ticket does not exist' do
      expect do
        get :show, params: { id: -1 }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
