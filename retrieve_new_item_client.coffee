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
    if newArticles.length is numOldArticles
        return false
    else
        return true
retrieveNewItem = (oldArticleObject, choiceKeywords)->
    #retrieves a single new item each time
    #later can make it retrieve multiple items
    newArticles = $("#container").find("article")
    newArticleObject = oldArticleObject

    bestChoiceHash = null
    bestIndexOfChoice = null
    hash = null
    for article in newArticles
        href = $(article).find("a").first().attr("href")
        if href not of oldArticleObject
            hash = href.split('/')
            hash = hash[hash.length-2..].join '/'
            newArticleObject[href] = true

            keywords = $(article).find("h1").first().find("a").first().text()
            keywords = keywords.split " "
            keywords = (k.toLowerCase() for k in keywords)
            found_kw = false

            indexOfChoice = 100
            for word,i in choiceKeywords
                `if (keywords.indexOf(word) > -1){
                    found_kw = true;
                    indexOfChoice = i;
                    break;
                }`
            if found_kw and (bestIndexOfChoice is null or indexOfChoice < bestIndexOfChoice)
                bestChoiceHash = hash
                bestIndexOfChoice = indexOfChoice
            if indexOfChoice is 0
                break
    if bestChoiceHash is not null
        hash = bestChoiceHash

    return [hash, newArticleObject, bestIndexOfChoice]

module.exports = [waitForNewItems, retrieveNewItem, findOldItems]
