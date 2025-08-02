import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="camera"
export default class extends Controller {
  // Define the HTML elements we need to interact with.
  // Stimulus will automatically find elements with data-camera-target="video", etc.
  static targets = [
    "video",
    "canvas",
    "startButton",
    "takeButton",
    "successMsg",
    "photoInput" // The actual file input field
  ]

  // This method runs automatically when the controller is connected to the page.
  connect() {
    console.log("Camera controller connected!");
  }

  // This method will be triggered by the "Start Camera" button.
  async start() {
    this.successMsgTarget.classList.add('d-none');

    try {
      const stream = await navigator.mediaDevices.getUserMedia({ video: true });
      this.videoTarget.srcObject = stream;
      this.stream = stream; // Store the stream so we can stop it later

      this.videoTarget.classList.remove('d-none');
      this.takeButtonTarget.classList.remove('d-none');
      this.startButtonTarget.classList.add('d-none');

    } catch (err) {
      console.error("Error accessing camera: ", err);
      alert("Could not access the camera. Please grant permission.");
    }
  }

  // This method will be triggered by the "Take Photo" button.
  takePhoto() {
    this.canvasTarget.width = this.videoTarget.videoWidth;
    this.canvasTarget.height = this.videoTarget.videoHeight;
    this.canvasTarget.getContext('2d').drawImage(this.videoTarget, 0, 0);

    this.canvasTarget.toBlob(blob => {
      const file = new File([blob], 'camera_photo.jpg', { type: 'image/jpeg' });
      const dataTransfer = new DataTransfer();
      dataTransfer.items.add(file);

      // Assign the captured photo to the file input target
      this.photoInputTarget.files = dataTransfer.files;

      this.cleanup();
    }, 'image/jpeg');
  }

  // Helper method to stop the camera and reset the UI.
  cleanup() {
    this.stream.getTracks().forEach(track => track.stop());

    this.videoTarget.classList.add('d-none');
    this.takeButtonTarget.classList.add('d-none');
    this.startButtonTarget.classList.remove('d-none');
    this.successMsgTarget.classList.remove('d-none');
  }
}
