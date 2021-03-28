import { Controller } from "stimulus"

export default class extends Controller {  
  static values = { actionmode: Boolean }
  
  shiftKeyIsPressed(event) {
    if (event.shiftKey) {
      this.actionmodeValue = true;
    }
  }
  
  shiftKeyIsReleased(event) {
    if (!event.shiftKey) {
      this.actionmodeValue = false;
    }
  }
}
