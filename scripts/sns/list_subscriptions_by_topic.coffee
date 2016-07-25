# Description:
#   List sns subscriptions by topic
#
# Commands:
#   hubot sns list subscriptions by topic --name="arn:aws..."

moment = require 'moment'
tsv    = require 'tsv'

module.exports = (robot) ->
  robot.respond /sns list subscriptions by topic --name=(.*)$/i, (msg) ->
    msg.send "Fetching ..."

    aws = require('../../aws.coffee').aws()
    sns  = new aws.SNS()

    sns.listSubscriptionsByTopic {topicArn: topicArn}, (err, response) ->
      if err
        msg.send "Error: #{err}"
      else
        msg.send(response.Subscriptions)
