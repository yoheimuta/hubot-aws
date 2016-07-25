# Description:
#   Publish a message to SNS
#
# Commands:
#   hubot sns publish --topicArn="arn:aws:sns:::..." --message="{}" --subject="Whatever"

module.exports = (robot) ->
  robot.respond /sns publish --topicArn=(.*?)(| --message)(| --subject)$/i, (msg) ->
    msg.send "Fetching ..."

    aws = require('../../aws.coffee').aws()
    sns  = new aws.SNS();

    sns.publish {
      topicArn: topicArn
    }, (err, response) ->
      if err
        msg.send "Error: #{err}"
      else
        msg.send(response.Subscriptions)
