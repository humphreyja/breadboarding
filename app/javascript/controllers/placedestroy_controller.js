import { Controller } from "stimulus"

// Element is a form
export default class extends Controller {
  static values = { position: Number }
  static targets = [ 'submit' ];
  
  removePlace(event) {
    if (this.hasSubmitTarget) {
      this.submitTarget.click();
      const evt = new CustomEvent("place:removed", { detail: { position: this.positionValue }});
      window.dispatchEvent(evt);
    }
  }
}
