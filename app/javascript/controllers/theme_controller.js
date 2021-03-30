import { Controller } from "stimulus"

export default class extends Controller { 
  changeToDarkTheme() {
    document.body.className = 'dark-theme';
  }
  
  changeToLightTheme() {
    document.body.className = 'light-theme';
  }
  
  changeToSystemTheme() {
    document.body.className = 'system-theme';
  }
}
