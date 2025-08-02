// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "bootstrap"

// In app/javascript/application.js or a similar file

document.addEventListener("turbo:load", function() {
  console.log("Turbo loaded. Camera script is trying to run.");

  const startCameraButton = document.getElementById("start-camera");
  const takePhotoButton = document.getElementById("take-photo");
  const video = document.getElementById("camera-stream");
  const canvas = document.getElementById("camera-canvas");
  const photoInput = document.getElementById("student_photo");
  const successMessage = document.getElementById("capture-success");

  // This check is important! It stops errors on pages without the camera button.
  if (!startCameraButton) {
    console.log("Camera button not found on this page. Script will not attach events.");
    return;
  }

  console.log("Camera button was found. Attaching click event.");

  let stream = null;

  startCameraButton.addEventListener("click", async () => {
    console.log("Start Camera button clicked.");
    try {
      // Check for secure context
      if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        alert("Camera API is not available in this browser or on an insecure connection.");
        console.error("getUserMedia not supported or not in a secure context.");
        return;
      }

      console.log("Requesting camera access...");
      stream = await navigator.mediaDevices.getUserMedia({ video: true });
      video.srcObject = stream;

      video.classList.remove("d-none");
      takePhotoButton.classList.remove("d-none");
      startCameraButton.classList.add("d-none");
      successMessage.classList.add("d-none");
      console.log("Camera stream started successfully.");

    } catch (err) {
      console.error("Error accessing camera: ", err);
      alert("Could not access the camera. Please ensure you have given permission and are on a secure (HTTPS or localhost) connection.");
    }
  });

  // (The rest of the "take photo" code remains the same)
  takePhotoButton.addEventListener("click", () => {
    // ... same code as before ...
  });
});
