# Description:
#   Publish a message to SNS
#
# Commands:
#   hubot sns publish --topicArn="arn:aws:sns:::..." --message="{}" --subject="Whatever"

module.exports = (robot) ->
  robot.respond /sns publish --topicArn=(.*?)(| --message)(| --subject)$/i, (msg) ->

    topicArn = if msg.match(/(--topicArn)(--topic)/) then true else false
    message = if msg.match(/(--message)(--msg)/) then true else false
    subject = if msg.match(/(--subject)(--subj)/) then true else false


    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact admin"
      return

    msg.send "Fetching ..."

    aws = require('../../aws.coffee').aws()
    sns  = new aws.SNS()

    sns.publish {
      topicArn: topicArn
    }, (err, response) ->
      if err
        msg.send "Error: #{err}"
      else
        msg.send(JSON.stringify(response))
