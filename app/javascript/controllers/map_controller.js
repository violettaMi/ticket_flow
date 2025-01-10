import { Controller } from "@hotwired/stimulus"
import "leaflet"

export default class extends Controller {
  static values = { polygonData: Array }

  connect() {
    const map = L.map(this.element).setView([32.072, -81.1], 12);

    L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(map);

    const polygon = L.polygon(this.polygonDataValue, {
      color: 'green',
      fillColor: '#3388ff',
      fillOpacity: 0.5
    }).addTo(map);

    map.fitBounds(polygon.getBounds());
  }
}
