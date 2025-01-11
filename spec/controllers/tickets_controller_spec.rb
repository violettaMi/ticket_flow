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

    context 'when paginated' do
      let!(:tickets) { create_list(:ticket, 50) }

      it 'returns the first page with default per-page limit' do
        get :index, params: { page: 1 }

        expect(assigns(:tickets).count).to eq(30)
      end

      it 'returns the second page with remaining tickets' do
        get :index, params: { page: 2 }

        expect(assigns(:tickets).count).to eq(20)
      end

      it 'returns an empty array if the page is out of bounds' do
        get :index, params: { page: 3 }

        expect(assigns(:tickets)).to be_empty
      end
    end
  end

  describe 'GET #show' do
    let(:dig_site_info) { 'POLYGON((30.1 10.1, 40.2 20.2, 20.3 30.3, 10.4 40.4, 30.1 10.1))' }
    let(:ticket) { create(:ticket, dig_site_info: dig_site_info) }
    let!(:excavator) { create(:excavator, ticket: ticket) }

    it 'assigns @ticket and @excavator' do
      get :show, params: { id: ticket.id }

      expect(assigns(:ticket)).to eq(ticket)
      expect(assigns(:ticket).excavator).to eq(excavator)
    end

    it 'assigns @polygon_coords correctly' do
      get :show, params: { id: ticket.id }

      expect(assigns(:polygon_coords)).to eq([
        [ 10.1, 30.1 ],
        [ 20.2, 40.2 ],
        [ 30.3, 20.3 ],
        [ 40.4, 10.4 ],
        [ 10.1, 30.1 ]
      ])
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
