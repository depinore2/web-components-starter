import { message } from './constants.js';
import { BaseWebComponent } from '../ts_modules/@depinore/wclibrary/BaseWebComponent.js'

console.log(`Message from the world: ${message}`);

export class AppComponent extends BaseWebComponent
{
    constructor() {
        super(`
        h2 {
            color: red; 
        }
        `, `<h2>This is coming from a web component!</h2>`);
    }
    connectedCallback() {
        // if(this.isConnected) {
        //     setTimeout(() => this.render(`<h4>The text should now be smaller, and black.</h4>`), 1000)
        // }
    }
    disconnectedCallback() {
        // Delete the element from DOM to see this get triggered.
        alert('The element got removed from the DOM.');
    }
}
customElements.define('depinore-app', AppComponent);