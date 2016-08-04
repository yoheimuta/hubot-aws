# Description:
#   Allows for Hubot to recieve push notifications from SNS
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_SNS_URL
#
# Commands:
#   None
#
# URLs:
#   /hubot/sns
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   mdouglass
{inspect} = require 'util'
{ verifySignature } = require './support/sns_message_verify'

Options =
  url: process.env.HUBOT_SNS_URL or '/hubot/sns'

class SNS
  constructor: (robot) ->
    @robot = robot

    @robot.router.post Options.url, (req, res) => @onMessage req, res

  onMessage: (req, res) ->
    chunks = []

    req.on 'data', (chunk) ->
      chunks.push(chunk)

    req.on 'end', =>
      req.body = JSON.parse(chunks.join(''))
      verifySignature req.body, (error) =>
        if error
          @robot.logger.warning "#{error}\n#{inspect req.body}"
          @fail req, res
        else
          @process req, res

  fail: (req, res) ->
    res.writeHead(500)
    res.end('Internal Error')

  process: (req, res) ->
    res.writeHead(200)
    res.end('OK')

    @robot.logger.debug "SNS Message: #{inspect req.body}"
    if req.body.Type == 'SubscriptionConfirmation'
      @confirmSubscribe req.body
    else if req.body.Type == 'UnsubscribeConfirmation'
      @confirmUnsubscribe
    else if req.body.Type == 'Notification'
      @notify req.body

  confirmSubscribe: (msg) ->
    @robot.emit 'sns:subscribe:request', msg

    @robot.http(msg.SubscribeURL).get() (err, res, body) =>
      if not err
        @robot.emit 'sns:subscribe:success', msg
      else
        @robot.emit 'sns:subscribe:failure', err
      return

  confirmUnsubscribe: (msg) ->
    @robot.emit 'sns:unsubscribe:request', msg
    @robot.emit 'sns:unsubscribe:success', msg

  notify: (msg) ->
    message =
      topic: msg.TopicArn.split(':').reverse()[0]
      topicArn: msg.TopicArn
      subject: msg.Subject
      message: msg.Message
      messageId: msg.MessageId

    @robot.emit 'sns:notification', message
    @robot.emit 'sns:notification:' + message.topic, message

module.exports = (robot) ->
  sns = new SNS robot

  robot.emit 'sns:ready', sns
