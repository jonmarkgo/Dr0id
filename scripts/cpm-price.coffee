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
        avg = response[0]["avg"]
        last = response[0]["last"]
        avg = avg.replace(/(\d+)(\d{3})/, '$1' + ',' + '$2') while (regex.test(avg))
        last = last.replace(/(\d+)(\d{3})/, '$1' + ',' + '$2') while (regex.test(last)) 
        msg.send "#{response[0]["name"]} | Avg: #{avg} | Last: #{last} | Listings: http://market.centrepointstation.com/browse.php?type=#{response[0]["type"]}&id=#{response[0]["id"]} | Stats: http://www.swcombine.com/rules/?#{response[0]["className"]}&ID=#{response[0]["id"]}"
      else
        msg.send "Error"