import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "helper" ]
  
  connect() {
    if (this.helperTarget) {
      const inputElement = this.element.querySelector('input, textarea');
      if (inputElement) {
        this.setTargetStyle(inputElement);
      }
    }
  }
  
  growHelper(event) {
    if (this.hasHelperTarget) {
      this.helperTarget.innerHTML = event.target.value;
      this.setTargetStyle(event.target);
      const evt = new CustomEvent("input:resize");
      window.dispatchEvent(evt);
    }
  }
  
  setTargetStyle(target) {
    target.style.width = this.helperTarget.offsetWidth + 8 + 'px';
    target.style.height = this.helperTarget.offsetHeight + 'px';
    
    
    
  }
}
