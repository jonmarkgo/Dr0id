# Description:
#   CPM Price Grabber
#
# Dependencies:
#   "apricot": "0.0.6"
#
# Configuration:
#   None
#
# Commands:
#   hubot price <ship> - gets price of a ship off CPM database
#
# Author:
#   jonmarkgo

Apricot = require('apricot').Apricot;

module.exports = (robot) ->
  robot.respond /(price )(.*)/i, (msg) ->
    Apricot.open 'http://db.centrepointstation.com/search.php?keywords=' + escape(msg.match[2]), (err, doc) ->
      doc.find 'td'
      doc.each (el) ->
        console.log el.innerHTML