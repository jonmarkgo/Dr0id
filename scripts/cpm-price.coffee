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

Bitly = require('bitly')

module.exports = (robot) ->
  bitly = new Bitly process.env.HUBOT_BITLY_USERNAME, process.env.HUBOT_BITLY_API_KEY
  robot.respond /(price) (.*)/i, (msg) ->
    keywords = msg.match[2]
    search_url = "http://db.centrepointstation.com/searchbot.php?keywords=#{escape(keywords)}&format=json"
    console.log search_url
    msg.http(search_url)
      .get() (err, res, body) ->
        if err
          msg.send "ERROR 1"
          return
        else
          try
            response = JSON.parse body
          catch e
            msg.send "ERROR 2"
            return
        if response.length > 1
          options = "";
          response.forEach (el) ->
            options = options + el["name"] + ", "
          options = options.replace(/(^\s*,)|(,\s*$)/g, '');
          msg.send "Did You Mean: " + options + "?"
        else if response[0]
          avg = response[0]["avg"].toString()
          last = response[0]["last"].toString()
          regex = /(\d+)(\d{3})/
          avg = avg.replace(regex, '$1' + ',' + '$2') while (regex.test(avg))
          last = last.replace(regex, '$1' + ',' + '$2') while (regex.test(last)) 
          window.cpm_url = "http://market.centrepointstation.com/browse.php?type=#{response[0]["type"]}&id=#{response[0]["id"]}"
          window.rules_url = "http://www.swcombine.com/rules/?#{response[0]["className"]}&ID=#{response[0]["id"]}"
          bitly.shorten window.cpm_url, (err, bresponse) ->
            if !err
              window.cpm_url = bresponse.data.url
          bitly.shorten window.rules_url, (err, bresponse) ->
            if !err
              window.rules_url = bresponse.data.url
          msg.send "#{response[0]["name"]} | Avg: #{avg} | Last: #{last} | Listings: #{window.cpm_url} | Stats: #{window.rules_url}"
        else
          msg.send "No such entity found!"