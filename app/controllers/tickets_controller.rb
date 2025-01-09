class TicketsController < ApplicationController
  def index
    @tickets = Ticket.includes(:excavator).order(created_at: :desc)
  end

  def show
    @ticket = Ticket.includes(:excavator).find(params[:id])
  end

  def map
    # print map
  end
end
