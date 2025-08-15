// app/javascript/application.js

import "@hotwired/turbo-rails"
import "controllers"
import "controllers/index"
import "bootstrap"

import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

// This is the most important line! It loads all your controller files.
import "controllers"
