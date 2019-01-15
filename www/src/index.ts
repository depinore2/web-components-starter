import { message } from './constants.js';
import { BaseWebComponent } from '../ts_modules/@depinore/wclibrary/BaseWebComponent.js'
import { Router } from '../node_modules/@vaadin/router/dist/vaadin-router.umd.js';

console.log(`Message from the world: ${message}`);

export class AppComponent extends BaseWebComponent
{
    router: any = null;
    constructor() {
        super(`
        h2 {
            color: red; 
        }
        `, 
        `<div id='outlet'></div>`);
    }
    connectedCallback() {
        if(this.shadowRoot) {
            const outlet = this.shadowRoot.querySelector('#outlet');
            
            // https://vaadin.github.io/vaadin-router/vaadin-router/demo/#vaadin-router-getting-started-demos
            this.router = new Router(outlet);
            this.router.setRoutes([
                { path: '/', component: 'depinore-it-works' }
            ])
        }
        else
            throw new Error('The shadowroot for this element is missing.');
    }   
    disconnectedCallback() {
        // Delete the element from DOM to see this get triggered.
        alert('The element got removed from the DOM.');
    }
}
customElements.define('depinore-app', AppComponent);

customElements.define('depinore-it-works', class extends BaseWebComponent {
    constructor() {
        super(``,`<h1>If you see this, it works!</h1>`)
    }
})