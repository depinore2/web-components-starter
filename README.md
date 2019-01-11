# Edgar's Web Component Starter #

## Why? ##

Because you're tired of webpack and all of these convoluted single-page application frameworks.

Because you want to use vanilla web components and no fluff on top of it.

## Tooling ##
* Some [PowerShell Core](https://github.com/powershell/powershell) Scripts, located in /automation
  * Powershell Core is cross-platform
* [TypeScript](https://www.typescriptlang.org/), because typos suck.
* [Browserify](http://browserify.org) because aint nobody got time for webpack.
* [http-server](https://www.npmjs.com/package/http-server) for development server.

## Libraries out of the box ##
* [Vaadin](https://vaadin.com/router) for routing.
* [Axios](https://www.npmjs.com/package/axios) for http calls.
* [DOMPurify](https://github.com/cure53/DOMPurify) To help you with protecting your HTML.

## How do I run this? ##

First of all, run `npm i`.  After all of your node packages have been installed, run 
```
automation/run.ps1
```
from a PowerShell Core terminal (`pwsh`).  This will open a bazillion windows and eventually bring up your browser.  The build tools are running in the background, in watch mode.

Every time you make a change to any of your TypeScript files, it will recompile your source code.  Make sure to reload your browser, and ensure the browser cache is turned off.
* [Disabling cache in Chrome](https://www.technipages.com/google-chrome-how-to-completely-disable-cache)
* [Disabling cache in Firefox](https://dzone.com/articles/how-turn-firefox-browser-cache)
* [Disabling cache in Internet Explorer 11](https://stackoverflow.com/questions/18083239/what-happened-to-always-refresh-from-server-in-ie11-developer-tools)
* [Disabling cache in Safari](https://forums.developer.apple.com/thread/87664)

## Building for Production ##
Run `automation/build_prod.ps1` from `pwsh`.  It takes two parameters:
* buildNumber
* destinationFolder

Example: 
~~~
pwsh automation/build_prod.ps1 -buildNumber 1.2.3.4 -destinationFolder ../out
~~~

It will do the following:
* Put all assets in a folder of your choosing.
* Build and minify all assets.
* Build an IE11 compatibilty mode build
* Keep only blob patterns listed in prodassets.json, and any `node_modules` listed as a "dependency".
* Any file that contains the string "--buildnumber--" will be replaced with the buildNumber you've provided.  This is used in the index.html to provide a unique build number and break the cache.

## Internet Explorer 11 ##
Care has been taken to make sure IE 11 can be supported.  If you work for an enterprise where a large part of your clients still use IE11 (like me), then this is key.

When in `run` mode, it will not automatically create the compatibility assets.  However, all you gotta do to make sure you got an IE build as well is:
```
pwsh automation/build.ps1 -withCompat
```
and that will also create a compatibility bundle file for Internet Explorer.

If you navigate to index.html from Internet Explorer, it will feature detect and navigate to index-compat.html.  The two pages should look identical, except that compatibility mode should say (Compatibility Mode) in the body.

## tsreferences.json ##
Any mappings that you provide in this folder will pull from other locations on disk and place them into your ts references folder (`ts_modules` by default) at build time.

This is useful if you want to reuse TypeScript source code from other projects, but need full control over how it is compiled.  The BaseWebComponent class uses this approach: It comes from `https://github.com/depinore/wclibrary`, is installed as npm module, and then pulled into your ts_modules.

This gives us the leverage to compile it both in regular mode and compatibility mode.