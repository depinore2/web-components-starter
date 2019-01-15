import { message } from './constants.js';
import { BaseWebComponent } from '../ts_modules/@depinore/wclibrary/BaseWebComponent.js'
import { default as routie } from '../node_modules/@prepair/routie/lib/index.js';

console.log(`Message from the world: ${message}`);

export class AppComponent extends BaseWebComponent
{
    router: any = null;
    constructor() {
        super(`
        h2 {
            color: red; 
        }
        `);
    }
    connectedCallback() {
        routie('', () => {
            this.render(`<depinore-it-works></depinore-it-works>`)
        })

        // go to #/view2/hello%20world to test this out.
        routie('/view2/:myParameter', myParameter => {
            this.render(`
                <h2>You navigated to another state</h2>
                <p>You provided the value <strong>${this.sanitize(myParameter)}</strong></p>
            `)
        })
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