# Pin npm packages by running ./bin/importmap

pin "application" # This pins app/javascript/application.js

pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

pin "bootstrap", to: "bootstrap.js", preload: true
pin "@popperjs/core", to: "popper.bundle.js", preload: true

# This line loads all your Stimulus controllers
pin "controllers/index", to: "controllers/index.js"

# 2. Pin every file that the loader imports
pin "controllers/application", to: "controllers/application.js"
pin "controllers/camera", to: "controllers/camera_controller.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "mdb-ui-kit", to: "mdb-ui-kit.js"
pin "tom-select" # @2.4.3
pin "@orchidjs/sifter", to: "@orchidjs--sifter.js" # @1.1.0
pin "@orchidjs/unicode-variants", to: "@orchidjs--unicode-variants.js" # @1.1.2
