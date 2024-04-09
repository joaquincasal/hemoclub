import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  delete(event) {
    event.target.parentNode.parentNode.removeChild(event.target.parentNode);
  }

  addCondition(event) {
    const ultimaCondicion = event.target.previousElementSibling;
    const nuevaCondicion = ultimaCondicion.cloneNode(true);
    ultimaCondicion.after(nuevaCondicion);
  }

  filename(event) {
    if (event.target.files.length) {
      document.getElementById("boton-importar").disabled = false;
      document.querySelector(".file-name").textContent = event.target.files[0].name;
    }
  }
}
