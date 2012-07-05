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

htmlparser = require "apricot"

module.exports = (robot) ->
  robot.respond /(price)(.*)/i, (msg) ->
    console.log msg.match[1]
    Apricot.open 'http://db.centrepointstation.com/search.php?keywords=' + escape(msg.match[1]), (err, doc) ->
      doc.find 'table > tbody > tr > td > table > tbody > tr > td > span'
      msg.send "html: #{doc.toHTML}"