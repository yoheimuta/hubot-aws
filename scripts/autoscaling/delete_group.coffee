# Description:
#   Delete autoscaling group
#
# Commands:
#   hubot autoscaling delete --group_name=[group_name] - Delete the AutoScaling Group
#   hubot autoscaling delete --group_name=[group_name] --force - Delete the AutoScaling Group with live instances

util = require 'util'

module.exports = (robot) ->
  robot.respond /autoscaling delete --group_name=(.*?)(| .*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    name  = msg.match[1].trim() || ''
    force = if msg.match[2].trim() == '--force' then true else false

    msg.send "Requesting #{name} #{force}..."

    aws = require('../../aws.coffee').aws()
    autoscaling = new aws.AutoScaling({apiVersion: '2011-01-01'})

    autoscaling.deleteAutoScalingGroup { AutoScalingGroupName: name, ForceDelete: force }, (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        msg.send util.inspect(res, false, null)
