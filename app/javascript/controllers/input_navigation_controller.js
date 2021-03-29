import { Controller } from "stimulus"

export default class extends Controller {
	static targets = ['input'];
	
  navigateOnEnter(event) {
    if (event.code === 'Enter') {
      event.preventDefault();
      if (event.shiftKey) {
        this.onEnterAndShiftKeyPressed(event.target, event);
      } else {
        this.onEnterKeyPressed(event.target, event);
      } 
    }
  }
  
  navigateBack(event) {
    if (event.detail && event.detail.trigger === 'backspace') {
      this.onEnterAndShiftKeyPressed(event.detail.target, event);
    }
  }
  
  onEnterKeyPressed(target, event) {
    for (let i = 0; i < this.navigationTargets.length; i++) {
      if (this.navigationTargets[i] === target) {
        if (i >= (this.navigationTargets.length - 1)) {
          if (target.value.length > 0) {
            // create
            const event = new CustomEvent('has-many:append', {bubbles: true, cancelable: true});
            target.dispatchEvent(event); 
          } else {
            event.preventDefault();
          }
        } else {
          this.navigationTargets[i + 1].focus();
        }
      }
    }
  }
  
  onEnterAndShiftKeyPressed(target) {
    for (let i = 0; i < this.navigationTargets.length; i++) {
      if (this.navigationTargets[i] === target) {
        if (i > 0) {
          this.navigationTargets[i - 1].focus();
          this.navigationTargets[i - 1].selectionStart = this.navigationTargets[i - 1].selectionEnd = this.navigationTargets[i - 1].value.length;
        }
      }
    }
  }
  
  get navigationTargets() {
    return this.inputTargets.filter((target) => {
      return !this.parentHasDeletedFlag(target);
    });
  }
  
  parentHasDeletedFlag(target) {
    if (target.parentElement === this.element) return false; // we've gone too far!
    if (target.parentElement.dataset.destroy) return true;
    return this.parentHasDeletedFlag(target.parentElement);
  }
}
