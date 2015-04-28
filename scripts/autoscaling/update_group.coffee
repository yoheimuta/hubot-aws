# Description:
#   Update autoscaling group
#   [json]
#     ex) { "AutoScalingGroupName": "test-group", "MinSize": 0, "MaxSize": 0 }
#     ex) { "AutoScalingGroupName": "test-group", "DesiredCapacity": 0 }
#
# Commands:
#   hubot autoscaling update --json=[json] --dry-run - Try updating the AutoScaling Group
#   hubot autoscaling update --json=[json] - Update the AutoScaling Group
#   hubot autoscaling update --name=[name] --min=[min] --dry-run - Try updating MinSize of the AutoScaling Group
#   hubot autoscaling update --name=[name] --min=[min] - Update MinSize of the AutoScaling Group
#   hubot autoscaling update --name=[name] --max=[max] --dry-run - Try updating MaxSize of the AutoScaling Group
#   hubot autoscaling update --name=[name] --max=[max] - Update MaxSize of the AutoScaling Group
#   hubot autoscaling update --name=[name] --desired=[desired] --dry-run - Try updating DesiredCapacity the AutoScaling Group
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
  robot.respond /autoscaling update --json=(.*?)(| --dry-run)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    json_str = msg.match[1].trim()
    dry_run = if msg.match[2] then true else false

    msg.send "Requesting json=#{json_str}, dry-run=#{dry_run}..."

    if dry_run
      msg.send util.inspect(JSON.parse(json_str), false, null)
      return

    update msg, JSON.parse(json_str)

  robot.respond /autoscaling update --name=(.*) --min=(.*?)(| --dry-run)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    name = msg.match[1]
    min  = msg.match[2]
    dry_run = if msg.match[3] then true else false
    return unless name
    return unless min

    msg.send "Requesting AutoScalingGroupName=#{name}, MinSize=#{min}, dry-run=#{dry_run}..."
    return if dry_run

    update msg, { AutoScalingGroupName: name, MinSize: min }

  robot.respond /autoscaling update --name=(.*) --max=(.*?)(| --dry-run)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    name = msg.match[1]
    max  = msg.match[2]
    dry_run = if msg.match[3] then true else false
    return unless name
    return unless max

    msg.send "Requesting AutoScalingGroupName=#{name}, MaxSize=#{max}, dry-run=#{dry_run}..."
    return if dry_run

    update msg, { AutoScalingGroupName: name, MaxSize: max }

  robot.respond /autoscaling update --name=(.*) --desired=(.*?)(| --dry-run)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    name     = msg.match[1]
    desired  = msg.match[2]
    dry_run = if msg.match[3] then true else false
    return unless name
    return unless desired

    msg.send "Requesting AutoScalingGroupName=#{name}, DesiredCapacity=#{desired}, dry-run=#{dry_run}..."
    return if dry_run

    update msg, { AutoScalingGroupName: name, DesiredCapacity: desired }
