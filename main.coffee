#Using NightmareJS (https://github.com/segmentio/nightmare)
#It's a wrapper around ElectronJS (more modern version of PhantomJS) and CasperJS
#Other options include PhantomJS, ElectronJS, CasperJS
#Lotte: https://github.com/StanAngeloff/lotte
#Ghostbuster: https://github.com/joshbuddy/ghostbuster
#
Nightmare = (require 'nightmare')
nightmare = Nightmare
    show: false
    switches:
        'ignore-certificate-errors': true
        'no-proxy-server': true
        'disable-renderer-backgrounding': true

result = nightmare
  .goto('http://yahoo.com')
  .type('form[action*="/search"] [name=p]', 'github nightmare')
  .click('form[action*="/search"] [type=submit]')
  .wait('#main')
  .evaluate( ->
      document.querySelector('#main .searchCenterMiddle li a').href
  ).end()

result
   .then((result)->
        console.log result
  ).catch (error)->
        console.error 'Search failed:', error


#commands:
#.back()
#
#.forward()
#
#.refresh()
#
#.mousedown(selector)
#
#.type(selector[, text]) (if need the keyboard events, mimicks keypresses)
#
#.insert(selector[, text]) (if don't need keyboard events)
#
#.check(selector)
#
#.uncheck(selector)
#
#.select(selector, option)
#
#.scrollTo(top, left)  (relative to top left corner of document)
#
#.viewport(width, height) (Set the viewport size.)
#
#.inject(type, file)   (must be js or css)
#
#.evaluate(fn[, arg1, arg2,...])
#    Invokes fn on the page with arg1, arg2,.... All the args are optional. On completion it returns the return value of fn. Useful for extracting information from the page. Here's an example:
#
#    var selector = 'h1';
#    nightmare
#      .evaluate(function (selector) {
#        // now we're executing inside the browser scope.
#        return document.querySelector(selector).innerText;
#       }, selector) // <-- that's how you pass parameters from Node scope to browser scope
#      .then(function(text) {
#        // ...
#      })
#
#.wait(ms)
#
#.wait(selector)
#
#    Wait until the element selector is present e.g. .wait('#pay-button')
#
#.wait(fn[, arg1, arg2,...])
#
#    Wait until the fn evaluated on the page with arg1, arg2,... returns true. All the args are optional. See .evaluate() for usage.
#
#.header([header, value])
#
#    Add a header override for all HTTP requests. If header is undefined, the header overrides will be reset.
#
#.exists(selector)
#
#Returns whether the selector exists or not on the page.
#
#.visible(selector)
#
#Returns whether the selector is visible or not
#
#.on(event, callback)
#
#Capture page events with the callback. You have to call .on() before calling .goto(). Supported events are documented here.
#
#
#.once(event, callback)
#
#Similar to .on(), but captures page events with the callback one time.
#
#.removeListener(event, callback)
#
#Removes a given listener callback for an event.
#
#.screenshot([path][, clip])
#
#Takes a screenshot of the current page. Useful for debugging. The output is always a png. Both arguments are optional. If path is provided, it saves the image to the disk. Otherwise it returns a Buffer of the image data. If clip is provided (as documented here), the image will be clipped to the rectangle.
#
#.html(path, saveType)
#
#Save the current page as html as files to disk at the given path. Save type options are here.
#
#.pdf(path, options)
#
#Saves a PDF to the specified path. Options are here.
#
#.title()
#
#Returns the title of the current page.
#
#.url()
#
#Returns the url of the current page.
#
#
#ALSO COOKIE EVENTS
