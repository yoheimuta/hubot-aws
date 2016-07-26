# Description:
#   Publish a message to SNS
#
# Commands:
#   hubot sns publish --topicArn="arn:aws:sns:::..." --message="{}" --subject="Whatever"

module.exports = (robot) ->
  robot.respond /sns publish(.*?)( |$)/i, (msg) ->

    topic_name_capture = /--topic=(.*?)( |$)/.exec(msg)
    topicArn = if msg.match(/--topic/) then topic_name_capture else msg.send('--topic required')
    message_capture = /--message=(.*?)( |$)/.exec(msg)
    message = if msg.match(/(--message)(--msg)/) then message_capture else msg.send('--message required')
    subject_capture = /--subject=(.*?)( |$)/.exec(msg)
    subject = if msg.match(/(--subject)(--subj)/) then subject_capture else msg.send('--subject required')

    msg.send "Publishing ..."

    aws = require('../../aws.coffee').aws()
    sns  = new aws.SNS()

    sns.publish {
      topicArn: topicArn,
      message: message,
      subject: subject
    }, (err, response) ->
      if err
        msg.send "Error: #{err}"
      else
        msg.send(JSON.stringify(response))
