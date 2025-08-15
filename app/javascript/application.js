// app/javascript/application.js

import "@hotwired/turbo-rails"
import "controllers"
import "controllers/index"
import "bootstrap"
import * as mdb from "mdb-ui-kit";

import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

// Configure MDB
import "mdb-ui-kit";

const initializeMdbComponents = () => {
  if (typeof window.mdb === 'undefined' || window.mdb === null) {
    console.error("MDB UI Kit did not load correctly. The 'window.mdb' object is missing.");
    return; // Stop execution if the library isn't there.
  }

  const dropdownElements = document.querySelectorAll('[data-mdb-dropdown-init]');

  dropdownElements.forEach((el) => {
    const Dropdown = window.mdb.Dropdown;

    if (Dropdown && !Dropdown.getInstance(el)) {
      new Dropdown(el);
    }
  });
};

document.addEventListener("turbo:load", initializeMdbComponents);
