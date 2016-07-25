# Description:
#   List sns subscriptions
#
# Commands:
#   hubot sns list subscriptions

module.exports = (robot) ->
  robot.respond /sns list subscriptions$/i, (msg) ->
    msg.send "Fetching ..."

    aws = require('../../aws.coffee').aws()
    sns  = new aws.SNS()

    sns.listSubscriptions {}, (err, response) ->
      if err
        msg.send "Error: #{err}"
      else
        msg.send(response.Subscriptions)
