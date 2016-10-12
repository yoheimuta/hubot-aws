# Description:
#   Delete an autoscaling notification
#
# Commands:
#   hubot autoscaling notification delete --group_name=[group_name] --arn=[topic_arn] - Delete the AutoScaling Notificatoin
#
# Notes:
#   --group_name=*** : [required] The name of the Auto Scaling group.
#   --arn=***        : [required] The Amazon Resource Name (ARN) of the Amazon Simple Notification Service (SNS) topic.

util = require 'util'

module.exports = (robot) ->
  robot.respond /autoscaling notification delete --group_name=(.*) --arn=(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact an admin."
      return

    group_name = msg.match[1].trim()
    topic_arn  = msg.match[2].trim()

    msg.send "Requesting group_name=#{group_name} topic_arn=#{topic_arn}..."

    aws = require('../../aws.coffee').aws()
    autoscaling = new aws.AutoScaling({apiVersion: '2011-01-01'})

    autoscaling.deleteNotificationConfiguration { AutoScalingGroupName: group_name, TopicARN: topic_arn}, (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        msg.send util.inspect(res, false, null)
