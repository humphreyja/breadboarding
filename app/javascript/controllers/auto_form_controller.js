import { Controller } from "stimulus"

function debounce(func, wait, immediate) {
	var timeout;
	return function() {
		var context = this, args = arguments;
		var later = function() {
			timeout = null;
			if (!immediate) func.apply(context, args);
		};
		var callNow = immediate && !timeout;
		clearTimeout(timeout);
		timeout = setTimeout(later, wait);
		if (callNow) func.apply(context, args);
	};
};

// Element is a form
export default class extends Controller {
  static targets = [ 'submit' ]
  
  connect() {
    this.submitFormDebounce = debounce(this.submitForm, 1000);
    
    function checkEnter(e){
      e = e || event;
      var txtArea = /textarea/i.test((e.target || e.srcElement).tagName);
      return txtArea || (e.keyCode || e.which || e.charCode || 0) !== 13;
    }
    this.element.onkeypress = checkEnter;
  }
  
  removeDestroyedItems(event) {
    this.element.querySelectorAll('[data-destroy="true"]').forEach((node) => {
      node.remove();
    })
  }
  
  debounceSubmit() {
    this.submitFormDebounce();
  }
  
  submitForm() {
    if (this.hasSubmitTarget) {
      this.submitTarget.click();
    }
  }
}
