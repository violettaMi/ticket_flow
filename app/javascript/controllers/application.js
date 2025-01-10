import { Application } from "@hotwired/stimulus"
import MapController from "./map_controller"

const application = Application.start()
application.register("map", MapController)

application.debug = false
window.Stimulus   = application

export { application }
