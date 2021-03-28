import { Controller } from "stimulus"

export default class extends Controller { 
  static values = { image: String, placePosition: Number }
  static targets = ['arrow', 'spacer', 'input']
   
  connect() {
    setTimeout(() => {
      if (this.hasInputTarget) {
        this.onHandleDrawArrow(this.getArrowDirection(parseInt(this.inputTarget.value)));
      }
    }, 100);
    
  }
  
  removeConnectionIfRemoved(event) {
    if (this.hasInputTarget && this.inputTarget.value) {
      const connectedToPosition = parseInt(this.inputTarget.value);
      if (connectedToPosition === event.detail.position) {
        this.removeDrawnArrow();
        if (this.hasInputTarget) {
          this.inputTarget.value = null;
          const evt = new CustomEvent("form:submit", {bubbles: true, cancelable: true});
          this.element.dispatchEvent(evt);
          this.wasConnected = false;
        }
      }
    }
  }
  
  redrawArrow(event) {
    if (this.hasInputTarget) {
      this.onHandleDrawArrow(this.getArrowDirection(parseInt(this.inputTarget.value)));
    }
  }
  
  // hovered over other place
  previewConnectToPlace(event) {
    if (this.isPreviewing) {  
      this.onHandleDrawArrow(this.getArrowDirection(event.detail.position))
    }
  }
  
  // click start connecting process
  activateConnection(event) {
    if (event.shiftKey) {
      this.isPreviewing = true;
      this.didConnect = false;
      this.canConnect = false;
      this.removeDrawnArrow();
      
      if (this.hasInputTarget && this.inputTarget.value) {
        this.wasConnected = true;
      }
    }
  }
  
  // click on other place to connect
  completeConnection(event) {
    if (this.isPreviewing) {
      if (this.onHandleDrawArrow(this.getArrowDirection(event.detail.position))) {
        this.createConnection(event.detail.position);
        this.isPreviewing = false;
      } else {
        this.didConnect = false;
      }
    }
  }
  
  // stopped holding shift so stop connecting. Remove any previews
  terminateConnectPreview(event) {
    if (!event.shiftKey) {
      if (this.isPreviewing && !this.didConnect) {
        this.removeDrawnArrow();
        if (this.wasConnected && this.hasInputTarget) {
          this.inputTarget.value = null;
          const evt = new CustomEvent("form:submit", {bubbles: true, cancelable: true});
          this.element.dispatchEvent(evt);
          this.wasConnected = false;
        }
      }

      this.isPreviewing = false;
    }
  }
  
  getArrowDirection(connectToPosition) {
    if (this.placePositionValue < 4) {
      if (connectToPosition == this.placePositionValue + 1) return 'right';
      if (connectToPosition == this.placePositionValue + 5) return 'down_right';
    } else if (this.placePositionValue === 4 && connectToPosition === 5) {
      return 'wrap';
    }
  }
  
  createConnection(position) {
    this.didConnect = true;
    if (this.hasInputTarget) {
      this.inputTarget.value = position;
      const evt = new CustomEvent("form:submit", {bubbles: true, cancelable: true});
      this.element.dispatchEvent(evt);
    }
  }
  
  onHandleDrawArrow(direction) {
    switch (direction) {
    case 'right':
      this.drawArrowRight(this.placePositionValue + 1);
      return true;
    case 'down_right':
      this.drawArrowDownRight(this.placePositionValue + 5);
      return true;
      break;
    case 'wrap':
      // const drawToPosition = this.placePositionValue + 1;
      // position + 1
      //draw arrow from end of row to start of next row
      break;
    default:
      this.removeDrawnArrow();
      return false;
        
    }
  }
  
  createArrowTargetIfMissing() {
    if (!this.hasArrowTarget) {
      const div = document.createElement("DIV");
      div.dataset.arrowTarget = 'arrow';
      div.dataset.connected = false;
      div.classList.add('arrow');
      this.element.appendChild(div);
    }
  }
  
  removeDrawnArrow() {
    if (this.hasArrowTarget) {
      this.arrowTarget.remove();
    }
  }
  
  drawArrowRight(position) {
    this.createArrowTargetIfMissing();
    const boardWidth = 200;
    const gutterWidth = 90;
    const margin = 15;
    const connectionNode = document.getElementById('place.' + position);
    if (connectionNode) {
      const arrowLeft = this.spacerTarget.getBoundingClientRect().width + margin;
      const arrowWidth = gutterWidth + (boardWidth - arrowLeft);
      
      
      const trueTop = this.spacerTarget.getBoundingClientRect().top + (this.spacerTarget.getBoundingClientRect().height / 2);
      
      const arrowHeight = trueTop - connectionNode.getBoundingClientRect().top;
      const arrowMarginTopBottom = (arrowHeight + (this.spacerTarget.getBoundingClientRect().height / 2)) * -1;
    
      this.arrowTarget.style.marginLeft = arrowLeft + 'px';
      this.arrowTarget.style.width = arrowWidth + 'px';
      this.arrowTarget.style.marginTop = arrowMarginTopBottom + 'px';
      this.arrowTarget.style.height = arrowHeight + 'px';
      this.arrowTarget.style.marginBottom = ((arrowMarginTopBottom + arrowHeight) * -1) + 'px';
      
      if (arrowHeight < 60) {
        this.imageValue = 'top-same-right';
      } else if (arrowHeight < 150) {
        if (arrowWidth < 100) {
          this.imageValue = 'middle-narrow-same-right';
        } else {
          this.imageValue = 'middle-same-right';
        }
      } else {
        this.imageValue = 'bottom-same-right';
      }
    }
  }
  
  drawArrowDownRight(position) {
    this.createArrowTargetIfMissing();
    const boardWidth = 200;
    const gutterWidth = 90;
    const margin = 15;
    const topMargin = 20;
    const connectionNode = document.getElementById('place.' + position);
    if (connectionNode) {
      
      const arrowLeft = this.spacerTarget.getBoundingClientRect().width + margin;
      const arrowWidth = gutterWidth + (boardWidth - arrowLeft);
      
      const arrowHeight = connectionNode.getBoundingClientRect().top - this.spacerTarget.getBoundingClientRect().top + topMargin;
      const arrowMarginTop = (this.spacerTarget.getBoundingClientRect().height * -1) + topMargin;
    
      this.arrowTarget.style.marginLeft = arrowLeft + 'px';
      this.arrowTarget.style.width = arrowWidth + 'px';
      this.arrowTarget.style.marginTop = arrowMarginTop + 'px';
      this.arrowTarget.style.height = arrowHeight + 'px';
      this.arrowTarget.style.marginBottom = ((arrowHeight + arrowMarginTop) * -1) + 'px';
      
      if (arrowHeight < 60) {
        this.imageValue = 'bottom-down-right';
      } else if (arrowHeight < 150) {
        this.imageValue = 'middle-down-right';
      } else {
        this.imageValue = 'top-down-right';
      }
    }
  }
}
