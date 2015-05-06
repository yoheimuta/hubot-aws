# Description:
#   Put autoscaling notifications
#
# Commands:
#   hubot autoscaling notification put --group_name=[group_name] --dry-run    - Try putting an AutoScaling Notifications
#   hubot autoscaling notification put --group_name=[group_name]   - Put an AutoScaling Notifications

cson = require 'cson'
util = require 'util'

module.exports = (robot) ->
  robot.respond /autoscaling notification put --group_name=(.*?)(| --dry-run)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    group_name = msg.match[1].trim()
    dry_run = if msg.match[2] then true else false

    msg.send "Requesting notifications, AutoScalingGroupName=#{group_name}, dry-run=#{dry_run}..."

    params = cson.parseCSONFile process.env.HUBOT_AWS_AS_NOTIFICATION

    aws = require('../../aws.coffee').aws()
    autoscaling = new aws.AutoScaling({apiVersion: '2011-01-01'})

    for param in params.NotificationConfigurations
      param.AutoScalingGroupName = group_name

      if dry_run
        msg.send util.inspect(param, false, null)
        continue

      autoscaling.putNotificationConfiguration param, (err, res)->
        if err
          msg.send "PutNotificationConfigurationError: #{err}"
          msg.send util.inspect(param, false, null)
          return
        msg.send util.inspect(res, false, null)
