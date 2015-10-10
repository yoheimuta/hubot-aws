# Description:
#   Put autoscaling notifications
#
# Commands:
#   hubot autoscaling notification put --group_name=[group_name] --dry-run - Try putting an AutoScaling Notifications
#   hubot autoscaling notification put --group_name=[group_name] --config_path=[filepath] - Put an AutoScaling Notifications

fs   = require 'fs'
cson = require 'cson'
util = require 'util'

getArgParams = (arg) ->
  dry_run = if arg.match(/--dry-run/) then true else false

  group_name_capture = /--group_name=(.*?)( |$)/.exec(arg)
  group_name = if group_name_capture then group_name_capture[1] else null

  config_path_capture = /--config_path=(.*?)( |$)/.exec(arg)
  config_path = if config_path_capture then config_path_capture[1] else null

  return {dry_run: dry_run, group_name: group_name, config_path: config_path}

module.exports = (robot) ->
  robot.respond /autoscaling notification put(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    arg_params = getArgParams(msg.match[1])

    dry_run     = arg_params.dry_run
    group_name  = arg_params.group_name
    config_path = arg_params.config_path

    config_path ||= process.env.HUBOT_AWS_AS_NOTIFICATION
    unless fs.existsSync config_path
      msg.send "NOT FOUND HUBOT_AWS_AS_NOTIFICATION"
      return

    params = cson.parseCSONFile config_path

    msg.send "Requesting notifications, group_name=#{group_name}, config_path=#{config_path}, dry-run=#{dry_run}..."

    aws = require('../../aws.coffee').aws()
    autoscaling = new aws.AutoScaling({apiVersion: '2011-01-01'})

    for param in params.NotificationConfigurations
      param.AutoScalingGroupName = group_name

      if dry_run
        msg.send util.inspect(param, false, null)
        continue

      autoscaling.putNotificationConfiguration param, (err, res) ->
        if err
          msg.send "PutNotificationConfigurationError: #{err}"
          msg.send util.inspect(param, false, null)
          return
        msg.send util.inspect(res, false, null)
