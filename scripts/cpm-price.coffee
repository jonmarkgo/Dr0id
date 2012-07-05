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
    Apricot.open('http://db.centrepointstation.com/search.php?keywords=' + encodeURIComponent(msg.match[1]), function(err, doc) {
      doc.find('table > tbody > tr > td > table > tbody > tr > td > span');
      msg.send "html: #{doc.toHTML}"
    }); 