import { Controller } from "stimulus"

// Element is a form
export default class extends Controller {
  static values = { position: Number }

  emitMouseOver(event) {
    if (event.shiftKey) {
      const evt = new CustomEvent("place:over", { detail: { position: this.positionValue }});
      window.dispatchEvent(evt);
    }
  }
  
  emitMouseClick(event) {
    if (event.shiftKey) {
      const evt = new CustomEvent("place:click", { detail: { position: this.positionValue }});
      window.dispatchEvent(evt);
    }
  }
}
