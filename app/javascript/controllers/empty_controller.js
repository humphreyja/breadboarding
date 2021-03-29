import { Controller } from "stimulus"

export default class extends Controller {  
  emitIfEmptyOnDoubleBackSpace(event) {
    if (event.code !== 'Backspace') {
      this.previousValue = null;
      return;
    }

    if (event.code === 'Backspace' && this.previousValue === '') {
      if (event.target.value === this.previousValue) {
        const event = new CustomEvent('input:empty', {bubbles: true, cancelable: true, detail: 'backspace' });
        this.element.dispatchEvent(event);    
      }
    }
    
    this.previousValue = event.target.value;
  }
  
  emitIfEmpty(event) {
    if (event.target.value.length === 0) {
      const event = new CustomEvent('input:empty', {bubbles: true, cancelable: true, detail: 'empty' });
      this.element.dispatchEvent(event);    
    }
  }
  
  emitIfEmptyPlaceOnDoubleBackSpace(event) {
    if (event.code !== 'Backspace') {
      this.previousValue = null;
      return;
    }

    if (event.code === 'Backspace' && this.previousValue === '') {
      if (event.target.value === this.previousValue) {
        const event = new CustomEvent('input:place:empty', {bubbles: true, cancelable: true});
        this.element.dispatchEvent(event);    
      }
    }
    
    this.previousValue = event.target.value;
  }
  
  emitIfEmptyPlace(event) {
    if (event.target.value.length === 0) {
      const event = new CustomEvent('input:place:empty', {bubbles: true, cancelable: true});
      this.element.dispatchEvent(event);    
    }
  }
}
