findOldItems = ->
    articles = $("#container").find("article")
    articleObject = {}
    for article in articles
        href = $(article).find("a").first().attr("href")
        articleObject[href] = true
    articleObject

waitForNewItems = (oldArticleObject)->
    numOldArticles = Object.keys(oldArticleObject).length
    newArticles = $("#container").find("article")
    console.log numOldArticles
    console.log newArticles.length
    if newArticles.length is numOldArticles
        return false
    else
        return true
retrieveNewItem = (oldArticleObject)->
    #retrieves a single new item each time
    #later can make it retrieve multiple items
    newArticles = $("#container").find("article")
    newArticleObject = oldArticleObject
    hash = null
    for article in newArticles
        href = $(article).find("a").first().attr("href")
        if href not of oldArticleObject
            hash = href.split('/')
            hash = hash[hash.length-1]
            newArticleObject[href] = true
            break
    return [hash, newArticleObject]

waitForNewItemsExtension = (articleObject, next)->
    (nightmare)->
        nightmare.wait(waitForNewItems, articleObject)
        .evaluate(retrieveNewItem, articleObject)
        .then( (returnVal) ->
            [hash, newArticleObject] = returnVal
            next(hash, newArticleObject)
        ).catch (err)->
            console.error "findAndSlectNewItem Failed:", err
            next(null, articleObject)

selectNewItem = module.exports = (oldItems, next)->
    (nightmare)->
        if oldItems
            nightmare.use waitForNewItemsExtension oldItems, next
        else
            nightmare.evaluate(findOldItems)
            .then (articleObject)->
                nightmare.use waitForNewItemsExtension articleObject, next
