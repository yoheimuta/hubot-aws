# Description:
#   Publish a message to SNS
#
# Commands:
#   hubot sns publish {message} to {message}

module.exports = (robot) ->
  robot.respond /sns publish (.*) to (.*)/i, (msg) ->
    topicArn = msg.match[2]
    message = msg.match[1]
    subject = "Hubot SNS Published"
    msg.send('Publishing to ' + msg.match[2])

    aws = require('../../aws.coffee').aws()
    sns = new aws.SNS()
    params = {
      TopicArn: topicArn,
      Message: message,
      Subject: subject
    }
    console.log(msg);
    sns.publish params, (err, response) ->
      if err
        msg.reply "Error: #{err}"
      else
        msg.reply JSON.stringify(response)
