# Description:
#   Put autoscaling scaling policy
#
# Configurations:
#   HUBOT_AWS_AS_POLICY_ADD    : [optional] Path to csonfile to be performs to add a scaleout policy based on. Required a config_path argument or this.
#   HUBOT_AWS_AS_POLICY_REMOVE : [optional] Path to csonfile to be performs to add a scalein policy based on. Required a config_path argument or this.
#   HUBOT_AWS_CW_ALARM_ADD     : [optional] Path to csonfile to be performs to add a scaleout alarm based on.
#   HUBOT_AWS_CW_ALARM_REMOVE  : [optional] Path to csonfile to be performs to add a scalein alarm based on.
#
# Commands:
#   hubot autoscaling policy put --add - Put an AutoScaling ScaleOut Policy
#   hubot autoscaling policy put --remove - Put an AutoScaling ScaleIn Policy
#
# Notes:
#   --add                   : [optional] The flag to add a scaleout policy. Required --add or --remove.
#   --remove                : [optional] The flag to add a scalein policy. Required --add or --remove.
#   --group_name=***        : [optional] The name of the group. If omit it, the AutoScalingGroupName of config is used.
#   --config_path=***       : [optional] Config file path. If omit it, HUBOT_AWS_AS_POLICY_ADD or HUBOT_AWS_AS_POLICY_REMOVE is referred to.
#   --alarm_config_path=*** : [optional] Userdata file path to be not encoded yet. If omit it, HUBOT_AWS_CW_ALARM_ADD or HUBOT_AWS_CW_ALARM_REMOVE is referred to.
#   --dry-run               : [optional] Checks whether the api request is right. Recommend to set before applying to real asset.

fs   = require 'fs'
cson = require 'cson'
util = require 'util'

getArgParams = (arg) ->
  dry_run = if arg.match(/--dry-run/) then true else false

  add_flag = if arg.match(/--add/) then true else false
  remove_flag = if arg.match(/--remove/) then true else false

  group_name_capture = /--group_name=(.*?)( |$)/.exec(arg)
  group_name = if group_name_capture then group_name_capture[1] else null

  config_path_capture = /--config_path=(.*?)( |$)/.exec(arg)
  config_path = if config_path_capture then config_path_capture[1] else null

  alarm_config_path_capture = /--alarm_config_path=(.*?)( |$)/.exec(arg)
  alarm_config_path = if alarm_config_path_capture then alarm_config_path_capture[1] else null

  return {dry_run: dry_run, add_flag: add_flag, remove_flag: remove_flag, group_name: group_name, config_path: config_path, alarm_config_path: alarm_config_path}

module.exports = (robot) ->
  robot.respond /autoscaling policy put(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    arg_params = getArgParams(msg.match[1])

    dry_run           = arg_params.dry_run
    add_flag          = arg_params.add_flag
    remove_flag       = arg_params.remove_flag
    group_name        = arg_params.group_name
    config_path       = arg_params.config_path
    alarm_config_path = arg_params.alarm_config_path

    unless add_flag || remove_flag
      msg.send "NOT FOUND --add or --remove"
      return

    config_path ||= if add_flag then process.env.HUBOT_AWS_AS_POLICY_ADD else process.env.HUBOT_AWS_AS_POLICY_REMOVE
    unless fs.existsSync config_path
      msg.send "NOT FOUND HUBOT_AWS_AS_POLICY_#{if add_flag then 'ADD' else 'REMOVE'}"
      return
    params = cson.parseCSONFile config_path
    params.AutoScalingGroupName = group_name

    alarm_params = null
    alarm_config_path ||= if add_flag then process.env.HUBOT_AWS_CW_ALARM_ADD else process.env.HUBOT_AWS_CW_ALARM_REMOVE
    if fs.existsSync alarm_config_path
      alarm_params = cson.parseCSONFile alarm_config_path
      alarm_params.AlarmName = "awsec2-#{group_name}-#{if add_flag then 'add' else 'remove'}"
      alarm_params.Dimensions = [{
        Name: 'AutoScalingGroupName',
        Value: group_name
      }]

    msg.send "Requesting policy, add_flag=#{add_flag}, remove_flag=#{remove_flag}, group_name=#{group_name}, config_path=#{config_path}, alarm_config_path=#{alarm_config_path}, dry-run=#{dry_run}..."

    if dry_run
      msg.send util.inspect(params, false, null)
      msg.send util.inspect(alarm_params, false, null)
      return

    aws = require('../../aws.coffee').aws()
    autoscaling = new aws.AutoScaling({apiVersion: '2011-01-01'})

    autoscaling.putScalingPolicy params, (err, res) ->
      if err
        msg.send "PutScalingPolicyError: #{err}"
        return
      msg.send util.inspect(res, false, null)

      unless alarm_params
        msg.send "Do not PutMetricAlarm. Done"
        return

      alarm_params.AlarmActions ?= []
      alarm_params.AlarmActions.push(res.PolicyARN)

      cloudwatch = new aws.CloudWatch({apiVersion: '2010-08-01'})
      cloudwatch.putMetricAlarm alarm_params, (err, res) ->
        if err
          msg.send "PutMetricAlarmError: #{err}"
          return
        msg.send util.inspect(res, false, null)
