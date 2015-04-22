# Description:
#   Update autoscaling group
#   [json]
#     ex) { "AutoScalingGroupName": "test-group", "MinSize": 0, "MaxSize": 0 }
#     ex) { "AutoScalingGroupName": "test-group", "DesiredCapacity": 0 }
#
# Commands:
#   hubot autoscaling update --json=[json] - Update the AutoScaling Group
#   hubot autoscaling update --name=[name] --min=[min] - Update MinSize of the AutoScaling Group
#   hubot autoscaling update --name=[name] --max=[max] - Update MaxSize of the AutoScaling Group
#   hubot autoscaling update --name=[name] --desired=[desired] - Update DesiredCapacity the AutoScaling Group

fs   = require 'fs'
cson = require 'cson'
util = require 'util'

update = (msg, json) ->
  aws = require('../../aws.coffee').aws()
  autoscaling = new aws.AutoScaling({apiVersion: '2011-01-01'})

  autoscaling.updateAutoScalingGroup json, (err, res)->
    if err
      msg.send "Error: #{err}"
    else
      msg.send util.inspect(res, false, null)

module.exports = (robot) ->
  robot.respond /autoscaling update --json=(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    json_str = msg.match[1].trim()

    msg.send "Requesting #{json_str}..."
    update msg, JSON.parse(json_str)

  robot.respond /autoscaling update --name=(.*) --min=(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    name = msg.match[1]
    min  = msg.match[2]
    return unless name
    return unless min

    msg.send "Requesting AutoScalingGroupName=#{name}, MinSize=#{min}..."
    update msg, { AutoScalingGroupName: name, MinSize: min }

  robot.respond /autoscaling update --name=(.*) --max=(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    name = msg.match[1]
    max  = msg.match[2]
    return unless name
    return unless max

    msg.send "Requesting AutoScalingGroupName=#{name}, MaxSize=#{max}..."
    update msg, { AutoScalingGroupName: name, MaxSize: max }

  robot.respond /autoscaling update --name=(.*) --desired=(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    name     = msg.match[1]
    desired  = msg.match[2]
    return unless name
    return unless desired

    msg.send "Requesting AutoScalingGroupName=#{name}, DesiredCapacity=#{desired}..."
    update msg, { AutoScalingGroupName: name, DesiredCapacity: desired }
