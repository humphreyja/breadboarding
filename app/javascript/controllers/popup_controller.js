import { Controller } from 'stimulus'

export default class extends Controller {
  static get targets() { return ['link'] }

  initialize() {
    if (this.hasLinkTarget) this.linkTarget.hidden = true
  }

  open() {
    this.element.open = true;
  }

  close() {
    this.element.open = false;
  }

  closeOnClickOutside({ target }) {
    if (this.element.contains(target)) {
      if (this.hasLinkTarget) {
        // Close if clicking a link in the menu
        if (target !== this.linkTarget && target.tagName === 'A' && !target.dataset.popupKeepalive) {
          this.close();
        }
      }

      if (target.dataset.popupDismiss) {
        this.close();
      }

      return
    }

    this.close()
  }

  update() {
    if (!this.element.open) return
    if (this.hasLinkTarget) this.linkTarget.click()
  }
}
