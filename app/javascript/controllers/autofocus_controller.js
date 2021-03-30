import { Controller } from "stimulus"

export default class extends Controller {
	static values = { focus: Boolean, selection: String }
	
  connect() {
    if (this.focusValue) {
      this.focusOnElement();
    }
  }
  
  focusValueChanged() {
    if (this.focusValue) {
      this.focusOnElement();
    }
  }
  
  focusOnElement() {
    this.element.focus();
     this.focusValue = false;
    if (this.element.value) {
      switch (this.selectionValue || 'end') {
      case 'start':
        this.element.selectionStart = this.element.selectionEnd = 0;
        break;
      case 'all':
        this.element.selectionStart = 0;
        this.element.selectionEnd = this.element.value.length;
        break;
      case 'end':
        this.element.selectionStart = this.element.selectionEnd = this.element.value.length;
        break;
      }
    }
  }
}
