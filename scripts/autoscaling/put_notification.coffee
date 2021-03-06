# Description:
#   Put autoscaling notifications
#
# Configurations:
#   HUBOT_AWS_AS_NOTIFICATION: [optional] Path to csonfile to be performs to add a notification based on. Required a config_path argument or this.
#
# Commands:
#   hubot autoscaling notification put - Put an AutoScaling Notifications
#
# Notes:
#   --group_name=***        : [optional] The name of the group. If omit it, the AutoScalingGroupName of config is used.
#   --config_path=***       : [optional] Config file path. If omit it, HUBOT_AWS_AS_NOTIFICATION is referred to.
#   --dry-run               : [optional] Checks whether the api request is right. Recommend to set before applying to real asset.

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
      msg.send "You cannot access this feature. Please contact an admin."
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
