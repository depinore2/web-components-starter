import * as purify from 'dompurify'

export abstract class BaseWebComponent extends HTMLElement
{
    constructor(styles: string, initialContent: string = '') {
        super();

        this.attachShadow({ mode: 'open' });
        
        const styleTag = document.createElement('style');
        styleTag.appendChild(document.createTextNode(styles));

        const contentTag = document.createElement('div');
        contentTag.setAttribute('id', 'content');

        if(this.shadowRoot !== null) {
            this.shadowRoot.appendChild(styleTag);
            this.shadowRoot.appendChild(contentTag);

            this.render(initialContent);
        }
        else
            throw new Error('ShadowRoot did not initialize properly.');
    }
    protected render(content: string, selector = ''): void 
    {
        const contentRoot = this.querySelector('#content');
        
        if(contentRoot === null) 
            throw new Error('Content root (#content) unexpectedly missing from element.');
        else {
            const renderRoot = selector === '' 
                                ? contentRoot
                                : contentRoot.querySelector(selector);
        }
    }
    protected generateSanitizer(): (content: string) => string {
        return content => purify.sanitize(content);
    }
    protected sanitize = this.generateSanitizer().bind(this);
}