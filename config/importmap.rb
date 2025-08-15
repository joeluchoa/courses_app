# Pin npm packages by running ./bin/importmap

pin "application" # This pins app/javascript/application.js

pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true

# This line loads all your Stimulus controllers
pin "controllers/index", to: "controllers/index.js"

# 2. Pin every file that the loader imports
pin "controllers/application", to: "controllers/application.js"
pin "controllers/camera", to: "controllers/camera_controller.js"
pin_all_from "app/javascript/controllers", under: "controllers"

