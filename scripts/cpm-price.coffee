# Description:
#   gets prices...
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
#   JonMarkGo

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
        handler = new HtmlParser.DefaultHandler()
        parser  = new HtmlParser.Parser handler
        parser.parseComplete body
        results = (Select handler.dom, 'td#main_content table tbody tr td table')
          .forEach el ->
            console.log(el)