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
        if response.length > 1 and response[0]["name"] != 'Shipyard I' and response[0]["name"] != 'Shipyard II' and response[0]["name"] != 'Golan I' and response[0]["name"] != 'Recycling I' and response[0]["name"] != 'Recycling II' and response[0]["name"] != 'Space Colony I' and response[0]["name"] != 'Trading I' and response[0]["name"] != 'R&D I' and response[0]["name"] != 'R&D II'
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
          cpm_url = "http://market.centrepointstation.com/browse.php?type=#{response[0]["type"]}&id=#{response[0]["id"]}"
          rules_url = "http://www.swcombine.com/rules/?#{response[0]["className"]}&ID=#{response[0]["id"]}"
          bitly.shorten cpm_url, (err, bresponse) ->
            if !err
              cpm_url = bresponse.data.url
            bitly.shorten rules_url, (err2, bresponse2) ->
              if !err2
                rules_url = bresponse2.data.url
              msg.notice "#{response[0]["name"]} | Avg: #{avg} | Last: #{last} | Listings: #{cpm_url} | Stats: #{rules_url}"
          
        else
          msg.send "No such entity found!"
