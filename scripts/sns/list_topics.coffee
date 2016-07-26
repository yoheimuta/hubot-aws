# Description:
#   List sns topics
#
# Commands:
#   hubot sns list topics

moment = require 'moment'
tsv    = require 'tsv'

module.exports = (robot) ->
  robot.respond /sns list topics$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact admin"
      return

    msg.send "Fetching ..."

    aws = require('../../aws.coffee').aws()
    sns  = new aws.SNS()

    sns.listTopics {}, (err, response) ->
      if err
        msg.send "Error: #{err}"
      else
        response.Topics.forEach (topic) ->
          msg.send(topic.TopicArn)
