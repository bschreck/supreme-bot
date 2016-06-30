[waitForNewItems, retrieveNewItem, findOldItems] = require './retrieve_new_item_client'



waitForNewItemsExtension = (articleObject, keywords, next)->
    (nightmare)->
        nightmare.wait(waitForNewItems, articleObject)
        #nightmare.wait(retrieveNewItem, articleObject, keywords)
        .evaluate(retrieveNewItem, articleObject, keywords)
        .then( (returnVal) ->
            [hash, newArticleObject, bestIndexOfChoice] = returnVal
            console.log "BEST INDEX:", bestIndexOfChoice
            next(hash, newArticleObject)
        ).catch (err)->
            console.error "findAndSelectNewItem Failed:", err
            next(null, articleObject)

selectNewItem = module.exports = (oldItems, keywords, next)->
    (nightmare)->
        if oldItems
            nightmare.use waitForNewItemsExtension oldItems, keywords, next
        else
            nightmare.evaluate(findOldItems)
            .then (articleObject)->
                nightmare.use waitForNewItemsExtension articleObject, keywords, next
