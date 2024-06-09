import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  delete(event) {
    event.target.parentNode.parentNode.removeChild(event.target.parentNode);
  }

  toggleProgramar(event) {
    const element = document.getElementById("programar");
    element.classList.toggle('is-hidden');
  }

  filename(event) {
    if (event.target.files.length) {
      document.getElementById("boton-importar").disabled = false;
      document.querySelector(".file-name").textContent = event.target.files[0].name;
    }
  }
}
