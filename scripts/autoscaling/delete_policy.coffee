# Description:
#   Delete an autoscaling policy
#
# Commands:
#   hubot autoscaling policy delete --group_name=[group_name] --policy_name=[policy_name] - Delete the AutoScaling Policy

util = require 'util'

module.exports = (robot) ->
  robot.respond /autoscaling policy delete --group_name=(.*) --policy_name=(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    group_name  = msg.match[1].trim()
    policy_name = msg.match[2].trim()

    msg.send "Requesting #{group_name} #{policy_name}..."

    aws = require('../../aws.coffee').aws()
    autoscaling = new aws.AutoScaling({apiVersion: '2011-01-01'})

    autoscaling.deletePolicy { AutoScalingGroupName: group_name, PolicyName: policy_name}, (err, res)->
      if err
        msg.send "Error: #{err}"
      else
        msg.send util.inspect(res, false, null)

