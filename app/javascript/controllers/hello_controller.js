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
  toggleBurger(event) {
    document.getElementsByClassName("navbar-burger")[0].classList.toggle("is-active");
    document.getElementsByClassName("navbar-menu")[0].classList.toggle("is-active");
  }

  setFechaExclusion(event) {
    const duracion = Number(event.target.value);
    const fechaInicio = new Date();
    document.getElementById("exclusion_fecha_inicio").valueAsDate = fechaInicio;
    const fechaFin = new Date(fechaInicio.setMonth(fechaInicio.getMonth() + duracion));
    document.getElementById("exclusion_fecha_fin").valueAsDate = fechaFin;
    document.getElementById("exclusion_motivo").value = event.target.options[event.target.selectedIndex].text;
  }
}
