// Import and register all your controllers from the importmap under controllers/*

import { application } from "./application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Manually register controllers
import BadgesController from "./badges_controller"
application.register("badges", BadgesController)
import SwipeController from "./swipe_controller"
application.register("swipe", SwipeController)
