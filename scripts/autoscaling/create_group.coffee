# Description:
#   Create autoscaling group
#
# Commands:
#   hubot autoscaling create --name=[group_name] --launch_name=[launch_configuration_name] --dry-run - Try creating an AutoScaling Group
#   hubot autoscaling create --name=[group_name] --launch_name=[launch_configuration_name] - Create an AutoScaling Group
#   hubot autoscaling create --name=[group_name] --launch_name=[launch_configuration_name] --capacity=[number] --dry-run - Try creating an AutoScaling Group with desiredCapacity
#   hubot autoscaling create --name=[group_name] --launch_name=[launch_configuration_name] --capacity=[number] - Create an AutoScaling Group with desiredCapacity

fs   = require 'fs'
cson = require 'cson'
util = require 'util'

create = (msg, params) ->
  aws = require('../../aws.coffee').aws()
  autoscaling = new aws.AutoScaling({apiVersion: '2011-01-01'})

  autoscaling.createAutoScalingGroup params, (err, res)->
    if err
      msg.send "Error: #{err}"
    else
      msg.send util.inspect(res, false, null)

module.exports = (robot) ->
  robot.respond /autoscaling create --name=(.*) --launch_name=(\S*?)(| --dry-run)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    name = msg.match[1].trim()
    conf = msg.match[2]
    dry_run = if msg.match[3] then true else false

    msg.send "Requesting name=#{name}, launch_name=#{conf}, dry-run=#{dry_run}..."

    config_path = process.env.HUBOT_AWS_AS_GROUP_CONFIG
    unless config_path
      msg.send "NOT FOUND HUBOT_AWS_AS_GROUP_CONFIG"
      return

    params = cson.parseCSONFile config_path
    params.AutoScalingGroupName    = name
    params.LaunchConfigurationName = conf

    if dry_run
      msg.send util.inspect(params, false, null)
      return

    create(msg, params)

  robot.respond /autoscaling create --name=(.*) --launch_name=(.*) --capacity=(.*?)(| --dry-run)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    name = msg.match[1].trim()
    conf = msg.match[2].trim()
    capacity = parseInt(msg.match[3].trim(), 10)
    dry_run = if msg.match[4] then true else false

    msg.send "Requesting name=#{name}, launch_name=#{conf}, capacity=#{capacity}, dry-run=#{dry_run}..."

    config_path = process.env.HUBOT_AWS_AS_GROUP_CONFIG
    unless config_path
      msg.send "NOT FOUND HUBOT_AWS_AS_GROUP_CONFIG"
      return

    params = cson.parseCSONFile config_path
    params.AutoScalingGroupName    = name
    params.LaunchConfigurationName = conf
    params.DesiredCapacity         = capacity
    params.MinSize                 = capacity

    if dry_run
      msg.send util.inspect(params, false, null)
      return

    create(msg, params)
