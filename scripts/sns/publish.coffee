# Description:
#   Publish a message to SNS
#
# Commands:
#   hubot sns publish --topicArn="arn:aws:sns:::..." --message="{}" --subject="Whatever"
getArgParams = (arg) ->
  topic_name_capture = /--topic=(.*?)( |$)/.exec(arg)
  topicArn = if arg.match(/--topic/) then topic_name_capture
  message_capture = /--message=(.*?)( |$)/.exec(arg)
  message = if arg.match(/(--message)(--msg)/) then message_capture else ""
  subject_capture = /--subject=(.*?)( |$)/.exec(arg)
  subject = if arg.match(/(--subject)(--subj)/) then subject_capture else "Test Message"
  return {topicArn: topicArn, message: message, subject: subject}

module.exports = (robot) ->
  robot.respond /sns publish(.*?)/i, (msg) ->
    console.log(msg);
    console.log(msg.match(1));
    arg_params = getArgParams(msg)

    msg.send "Publishing ..."

    aws = require('../../aws.coffee').aws()
    sns = new aws.SNS()

    sns.publish {
      TopicArn: arg_params.topicArn,
      Message: arg_params.message,
      Subject: arg_params.subject
    }, (err, response) ->
      if err
        msg.send "Error: #{err}"
      else
        msg.send(JSON.stringify(response))
