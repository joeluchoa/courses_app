import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = ["result", "reader"]

  connect() {
    // Bind event listeners once and store them, ensuring they can be removed correctly.
    this.handleBeforeVisit = this.handleBeforeVisit.bind(this)
    document.addEventListener("turbo:before-visit", this.handleBeforeVisit)

    // --- THE SINGLETON LOGIC ---
    if (window.activeScanner) {
      console.log("Reusing existing scanner.");
      // If a scanner already exists, we adopt it.
      // The most crucial step is to ensure the UI is in the right place.
      // The library's `render` method is designed to be called multiple times.
      // It will move the UI into the new target if necessary.
      window.activeScanner.render(this.onScanSuccess.bind(this), this.onScanFailure.bind(this));
    } else {
      console.log("Creating new scanner.");
      // If no scanner exists, we create it for the first time.
      const scanner = new Html5QrcodeScanner(
        this.readerTarget.id,
        { fps: 10, qrbox: { width: 250, height: 250 }, ricordLastUsedCamera: true },
        false
      );
      // Store it globally so it persists across Turbo navigations.
      window.activeScanner = scanner;
      scanner.render(this.onScanSuccess.bind(this), this.onScanFailure.bind(this));
    }
    this.isScanning = true;
  }

  disconnect() {
    // When the controller disconnects, we MUST remove its event listeners to prevent memory leaks.
    document.removeEventListener("turbo:before-visit", this.handleBeforeVisit)
  }

  // This Turbo event listener is our reliable cleanup mechanism.
  handleBeforeVisit(event) {
    // We only destroy the scanner if the user is navigating to a page that
    // is NOT the scanner page. This allows the singleton to persist
    // during the Turbo preview/render cycle of the scanner page itself.
    if (!event.detail.url.includes("/scanner")) {
      console.log("Navigating away from scanner, destroying singleton.");
      if (window.activeScanner) {
        window.activeScanner.clear().catch(err => console.error("Failed to clear scanner on navigation:", err));
        window.activeScanner = null;
      }
    }
  }

  onScanSuccess(decodedText, decodedResult) {
    if (!this.isScanning) {
      return;
    }

    const parts = decodedText.split('-');
    const studentId = parseInt(parts[0]);
    const courseId = parseInt(parts[1]);

    if (isNaN(studentId) || isNaN(courseId)) {
      this.showFeedback("Invalid QRCode! Please try again.", "danger");
    } else {
      this.isScanning = false;
      this.showFeedback("Scan successful! Redirecting...", "success");

      // We no longer stop the scanner here. We let the `handleBeforeVisit`
      // event handle the cleanup when Turbo navigates away.
      const targetUrl = `/scanner/confirm?student_id=${studentId}&course_id=${courseId}`;
      Turbo.visit(targetUrl);
    }
  }

  onScanFailure(error) {
    // Intentionally left blank.
  }

  showFeedback(message, type) {
    if (this.feedbackTimeout) clearTimeout(this.feedbackTimeout);
    const feedbackEl = this.resultTarget;
    feedbackEl.innerHTML = message;
    feedbackEl.className = `alert alert-${type} mt-3`;
    this.feedbackTimeout = setTimeout(() => {
      feedbackEl.innerHTML = '';
      feedbackEl.className = '';
    }, 3000);
  }
}
