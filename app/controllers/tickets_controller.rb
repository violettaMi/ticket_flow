class TicketsController < ApplicationController
  def index
    @tickets = Ticket.includes(:excavator).order(created_at: :desc)
  end

  def show
    @ticket = Ticket.includes(:excavator).find(params[:id])
  end

  def create
    # TODO: add api tickets controller and call CreateTicket entry point
  end
end
