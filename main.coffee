#Using NightmareJS (https://github.com/segmentio/nightmare)
#It's a wrapper around ElectronJS (more modern version of PhantomJS) and CasperJS
#Other options include PhantomJS, ElectronJS, CasperJS
#Lotte: https://github.com/StanAngeloff/lotte
#Ghostbuster: https://github.com/joshbuddy/ghostbuster
#
fs = require 'fs'
Xvfb = require('xvfb')
Nightmare = (require 'nightmare')
xvfb = new Xvfb
    silent: true
xvfb.startSync()
nightmare = Nightmare
    show: false
    switches:
        'ignore-certificate-errors': true
        'no-proxy-server': true
        'disable-renderer-backgrounding': true

creditCardTypeFormat = (ctype)->
    switch ctype
        when "Visa" then "visa"
        when "American Express" then "american_express"
        when "Mastercard" then "master"
        else "visa"
loadOptions = ()->
    data = JSON.parse(fs.readFileSync 'secrets.json')
    data.cardType = creditCardTypeFormat(data.cardType)
    data
gOptions = loadOptions()
getSize = ->
    gOptions.size

buildURL = (siteFunction, itemType, hash)->
    mainSite = 'www.supremenewyork.com'
    if siteFunction == "shop"
        return "http://#{mainSite}/#{siteFunction}/#{itemType}/#{hash}"
    else
        return "https://#{mainSite}/#{siteFunction}"
addToCartInjection = (clothingSize)->
    options = []
    option = null
    for option in $('select[name*=size] option')
        if $(option).text() is clothingSize
            option = $(option).val()
            break
        options.push $(option).val()
    if not option?
        option = options[0]
    $('select[name*="size"]').val(option)
    $('input[value="add to cart"]').click()
    return true
addToCart = (next)->
    (nightmare)->
        nightmare.goto(buildURL "shop", "t-shirts", "dcs7fu6dn")
        #.inject('js', 'node_modules/jquery/dist/jquery.min.js')
        .evaluate(addToCartInjection, getSize())
        .then (val)->
            console.log val
            nightmare.wait('form[action*="/remove"]')
            next(nightmare)


inputCreditCardInfo = (inputs)->
    $('input[name="order[billing_name]"]')     .val inputs.name
    $('input[name="order[email]"]')            .val inputs.email
    $('input[name="order[tel]"]')              .val inputs.tel
    $('input[name="order[billing_address]"]')  .val inputs.address1
    $('input[name="order[billing_address_2]"]').val inputs.address2
    $('input[name="order[billing_city]"]')     .val inputs.city
    $('input[name="order[billing_zip]"]')      .val inputs.zip
    $('select[name*="country"]')               .val inputs.country
    $('select[name*="state"]')                 .val inputs.state
    $('select[name="credit_card[type]"]')      .val inputs.cardType
    cardInputs = $("#card_details").find("input")
    $(cardInputs[0])                           .val inputs.cardNum
    $(cardInputs[1])                           .val inputs.cvc
    $('select[name*="credit_card[month]"]')    .val inputs.expMonth
    $('select[name*="credit_card[year]"]')     .val inputs.expYear
    $("#cart-cc").find(".icheckbox_minimal").click ->
        $('input[class*="checkout"],input[type="submit"]').click()
    $("#cart-cc").find(".icheckbox_minimal").click()




checkout = (nightmare)->
    nightmare.goto(buildURL "checkout")
    .evaluate(inputCreditCardInfo, gOptions)


nightmare.use addToCart (nightmare)->
    nightmare.use checkout
    .wait('div[class="errors"]')
    .screenshot("/Users/bschreck/supreme_bot/supreme_shot.png")
    .end()
    .then( (val)->
        console.log "Val:",val
        console.log "Success"
        xvfb.stop()
    ).catch (err)->
        console.error "Failed:",err


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
