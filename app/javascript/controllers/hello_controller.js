import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  delete(event) {
    event.target.parentNode.parentNode.removeChild(event.target.parentNode);
  }
}
