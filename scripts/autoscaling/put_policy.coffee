# Description:
#   Put autoscaling scaling policy
#
# Commands:
#   hubot autoscaling policy put --add --group_name=[group_name] --dry-run    - Try putting an AutoScaling ScaleOut Policy
#   hubot autoscaling policy put --add --group_name=[group_name]    - Put an AutoScaling ScaleOut Policy
#   hubot autoscaling policy put --remove --group_name=[group_name] --dry-run - Try putting an AutoScaling ScaleIn Policy
#   hubot autoscaling policy put --remove --group_name=[group_name] - Put an AutoScaling ScaleIn Policy

cson = require 'cson'
util = require 'util'

putPolicy = (msg, params, alarm_params) ->
  aws = require('../../aws.coffee').aws()
  autoscaling = new aws.AutoScaling({apiVersion: '2011-01-01'})

  autoscaling.putScalingPolicy params, (err, res)->
    if err
      msg.send "PutScalingPolicyError: #{err}"
      return
    msg.send util.inspect(res, false, null)

    alarm_params.AlarmActions ?= []
    alarm_params.AlarmActions.push(res.PolicyARN)

    cloudwatch = new aws.CloudWatch({apiVersion: '2010-08-01'})
    cloudwatch.putMetricAlarm alarm_params, (err, res)->
      if err
        msg.send "PutMetricAlarmError: #{err}"
        return
      msg.send util.inspect(res, false, null)


module.exports = (robot) ->
  robot.respond /autoscaling policy put --add --group_name=(.*?)(| --dry-run)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    group_name = msg.match[1].trim()
    dry_run = if msg.match[2] then true else false

    msg.send "Requesting add policy, AutoScalingGroupName=#{group_name}, dry-run=#{dry_run}..."

    params = cson.parseCSONFile process.env.HUBOT_AWS_AS_POLICY_ADD
    params.AutoScalingGroupName = group_name

    alarm_params = cson.parseCSONFile process.env.HUBOT_AWS_CW_ALARM_ADD
    alarm_params.AlarmName = "awsec2-#{group_name}-add"
    alarm_params.Dimensions = [{
      Name: 'AutoScalingGroupName',
      Value: group_name
    }]

    if dry_run
      msg.send util.inspect(params, false, null)
      msg.send util.inspect(alarm_params, false, null)
      return

    putPolicy msg, params, alarm_params

  robot.respond /autoscaling policy put --remove --group_name=(.*?)(| --dry-run)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    group_name = msg.match[1].trim()
    dry_run = if msg.match[2] then true else false

    msg.send "Requesting remove policy, AutoScalingGroupName=#{group_name}, dry-run=#{dry_run}..."

    params = cson.parseCSONFile process.env.HUBOT_AWS_AS_POLICY_REMOVE
    params.AutoScalingGroupName = group_name

    alarm_params = cson.parseCSONFile process.env.HUBOT_AWS_CW_ALARM_REMOVE
    alarm_params.AlarmName = "awsec2-#{group_name}-remove"
    alarm_params.Dimensions = [{
      Name: 'AutoScalingGroupName',
      Value: group_name
    }]

    if dry_run
      msg.send util.inspect(params, false, null)
      msg.send util.inspect(alarm_params, false, null)
      return

    putPolicy msg, params, alarm_params
