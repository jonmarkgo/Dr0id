# Description:
#   Webutility returns title of urls
#
# Dependencies:
#   "htmlparser": "1.7.6"
#   "soupselect": "0.2.0"
#   "jsdom": "0.2.14"
#
#
# Commands:
#   None
#
# Author:
#   KevinTraver

Select     = require("soupselect").select
HtmlParser = require "htmlparser"
JSDom      = require "jsdom"

# Decode HTML entities
unEntity = (str) ->
    e = JSDom.jsdom().createElement("div")
    e.innerHTML = str
    if e.childNodes.length == 0 then "" else e.childNodes[0].nodeValue

module.exports = (robot) ->
  robot.respond /(price )(.*)/i, (msg) ->
    msg
      .http('http://db.centrepointstation.com/search.php?keywords=' + escape(msg.match[2]))
      .get() (err, res, body) ->
        if res.statusCode is 301 or res.statusCode is 302
          httpResponse(res.headers.location)
        else if res.statusCode is 200
          handler = new HtmlParser.DefaultHandler()
          parser  = new HtmlParser.Parser handler
          parser.parseComplete body
          results = (Select handler.dom, 'td#main_content table tbody tr td table')
          console.log(results[0])