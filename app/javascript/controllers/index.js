import { application } from "./application"

import GraphController from "./graph_controller"
application.register("graph", GraphController)

import WebauthnController from "./webauthn_controller"
application.register("webauthn", WebauthnController)
