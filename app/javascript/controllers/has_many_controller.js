import { Controller } from "stimulus"

export default class extends Controller {
	static get targets() { return ['container', 'template'] }
	
  insertTemplateIntoContainer() {
    // if (!this.hasContainerTarget || !this.hasTemplateTarget) return;
    
    let template = this.templateTarget.content.firstElementChild.cloneNode(true);
    template.innerHTML = template.innerHTML.replace(/INDEX/g, new Date().getTime());
    this.containerTarget.appendChild(template);
  }
  
  removeFromContainer(event) {
    const containerItemTarget = this.findContainerItemFromTarget(event.target);
    if (!containerItemTarget) return;
    
    // look for _destroy attribute, you must render a hidden field for it to be destroyed
    const destroyField = containerItemTarget.querySelector('[name*=_destroy]');
    if (destroyField) {
      destroyField.value = 'true';
      containerItemTarget.style.display = "none";
      containerItemTarget.dataset.destroy = true;
      
      
      const event = new CustomEvent('has-many:removed', {bubbles: true, cancelable: true});
      this.element.dispatchEvent(event);      
    } else {
      containerItemTarget.remove();
    }
    
  }
  
  findContainerItemFromTarget(target) {
    if (target.parentElement === document.body) return null; // we've gone too far!
    if (target.parentElement === this.containerTarget) return target;
    return this.findContainerItemFromTarget(target.parentElement);
  }
  
  refocusOnPreviousSibling(node) {
    const previous = node.previousSibling;
    if (previous) {
      if (previous.nodeName === '#text') {
        this.refocusOnPreviousSibling(previous);
      } else {
        previous.querySelector('input[type="text"]').focus();
      }
    }
  }
}
