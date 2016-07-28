# Description:
#   List sns subscriptions by topic
#
# Commands:
#   hubot sns list subscriptions in topic arn:aws...

module.exports = (robot) ->

  robot.respond /sns list subscriptions in (.*)$/i, (msg) ->

    topic = msg.match[1]

    msg.send "Fetching subscriptions for " + topic

    aws = require('../../aws.coffee').aws()
    sns  = new aws.SNS()

    sns.listSubscriptionsByTopic {TopicArn: topic}, (err, response) ->
      if err
        msg.send "Error: #{err}"
      else
        response.Subscriptions.forEach (subscription) ->
          labels = Object.keys(subscription)
          labels.forEach (label) ->
            msg.send(label + " " + subscription[label])
          msg.send "____________________________________"
