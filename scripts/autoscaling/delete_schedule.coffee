# Description:
#   Delete an autoscaling schduled action
#
# Commands:
#   hubot autoscaling schedule delete --schedule_name=[policy_name] - Delete the AutoScaling Scheduled Action
#
# Notes:
#   --schedule_name=*** : [required] The name of the action to delete.
#   --group_name=***    : [optional] The name of the Auto Scaling group.

util = require 'util'

getArgParams = (arg) ->
  group_name_capture = /--group_name=(.*?)( |$)/.exec(arg)
  group_name = if group_name_capture then group_name_capture[1] else null

  schedule_name_capture = /--schedule_name=(.*?)( |$)/.exec(arg)
  schedule_name = if schedule_name_capture then schedule_name_capture[1] else null

  return {group_name: group_name, schedule_name: schedule_name}

module.exports = (robot) ->
  robot.respond /autoscaling schedule delete(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact an admin."
      return

    arg_params = getArgParams(msg.match[1])
    group_name = arg_params.group_name
    schedule_name = arg_params.schedule_name

    unless schedule_name
      msg.send "NOT FOUND --schedule_name"
      return
    params.ScheduledActionName = schedule_name

    if group_name != null
      params.AutoScalingGroupName = group_name

    msg.send "Requesting group_name=#{group_name} schedule_name=#{schedule_name}..."

    aws = require('../../aws.coffee').aws()
    autoscaling = new aws.AutoScaling({apiVersion: '2011-01-01'})

    autoscaling.deleteScheduledAction params, (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        msg.send util.inspect(res, false, null)
