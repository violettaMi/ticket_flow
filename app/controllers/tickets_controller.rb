class TicketsController < ApplicationController
  def index
    @tickets = Ticket.includes(:excavator).order(created_at: :desc).page(params[:page]).per(30)
  end

  def show
    @ticket = Ticket.includes(:excavator).find(params[:id])

    @polygon_coords = parse_wkt_polygon(@ticket.dig_site_info)
  end


  private

  def parse_wkt_polygon(wkt)
    coords = wkt.match(/POLYGON\(\((.*)\)\)/)[1]

    coords.split(",").map do |pair|
      lng, lat = pair.split.map(&:to_f)
      [ lat, lng ]
    end
  end
end
