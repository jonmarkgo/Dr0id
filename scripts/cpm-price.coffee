# Description:
#   CPM Price Grabber
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot price <ship> - gets price of a ship off CPM database
#
# Author:
#   jonmarkgo

module.exports = (robot) ->
  robot.respond /(price) (.*)/i, (msg) ->
   keywords = msg.match[2]
   url = "http://db.centrepointstation.com/searchbot.php?keywords=#{escape(keywords)}&format=json"
   console.log url
   msg.http(url)
    .get() (err, res, body) ->
      response = JSON.parse body
      if response[0]
       msg.send response[0]["name"] + ' average price= ' + response[0]["avg"]
      else
       msg.send "Error"