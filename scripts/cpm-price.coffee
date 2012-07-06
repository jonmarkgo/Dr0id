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
   msg.http("http://db.centrepointstation.com/searchbot.php?keywords=#{escape(keywords)}&format=json")
    .get() (err, res, body) ->
      response = JSON.parse body
      if response.length > 1
      	options = "";
      	response.forEach (el) ->
          options = options + el["name"] + ", "
      	msg.send "Did You Mean: " + options
      else if response[0]
       msg.send "" + response[0]["name"] + " | Avg: " + response[0]["avg"] + " | Last: " + response[0]["last"] + " | Listings: http://market.centrepointstation.com/browse.php?type="+response[0]["type"]+"&class="+response[0]["class"]+"&id="+response[0]["id"]
     //rules: http://www.swcombine.com/rules/?"+response[0]["className"] + "&ID="+response[0]["id"]
      else
       msg.send "Error"