# Description:
#   Create autoscaling group
#
# Configurations:
#   HUBOT_AWS_AS_GROUP_CONFIG: [optional] Path to csonfile to be performs service operation based on. Required a config_path argument or this.
#
# Commands:
#   hubot autoscaling create - Create an AutoScaling Group
#
# Notes:
#   --name=***        : [optional] The name of the group. If omit it, the AutoScalingGroupName of config is used.
#   --launch_name=*** : [optional] The name of the launch configuration. If omit it, the LaunchConfigurationName of config is used.
#   --capacity=***    : [optional] The size of the group to be applied to min, max and desired. If omit it, each MinSize/MaxSize/DesiredCapacity of config is used.
#   --config_path=*** : [optional] Config file path. If omit it, HUBOT_AWS_AS_GROUP_CONFIG is referred to.
#   --dry-run         : [optional] Checks whether the api request is right. Recommend to set before applying to real asset.

fs   = require 'fs'
cson = require 'cson'
util = require 'util'

getArgParams = (arg) ->
  dry_run = if arg.match(/--dry-run/) then true else false

  name_capture = /--name=(.*?)( |$)/.exec(arg)
  name = if name_capture then name_capture[1] else null

  launch_name_capture = /--launch_name=(.*?)( |$)/.exec(arg)
  launch_name = if launch_name_capture then launch_name_capture[1] else null

  capacity_capture = /--capacity=(.*?)( |$)/.exec(arg)
  capacity = if capacity_capture then capacity_capture[1] else null

  config_path_capture = /--config_path=(.*?)( |$)/.exec(arg)
  config_path = if config_path_capture then config_path_capture[1] else null

  return {dry_run: dry_run, name: name, launch_name: launch_name, capacity: capacity, config_path: config_path}

module.exports = (robot) ->
  robot.respond /autoscaling create(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact an admin."
      return

    arg_params = getArgParams(msg.match[1])

    dry_run     = arg_params.dry_run
    name        = arg_params.name
    launch_name = arg_params.launch_name
    capacity    = arg_params.capacity
    config_path = arg_params.config_path

    config_path ||= process.env.HUBOT_AWS_AS_GROUP_CONFIG
    unless fs.existsSync config_path
      msg.send "NOT FOUND HUBOT_AWS_AS_GROUP_CONFIG"
      return

    params = cson.parseCSONFile config_path
    params.AutoScalingGroupName    = name if name
    params.LaunchConfigurationName = launch_name if launch_name
    params.DesiredCapacity         = capacity if capacity
    params.MinSize                 = capacity if capacity
    params.MaxSize                 = capacity if capacity

    msg.send "Requesting name=#{name}, launch_name=#{launch_name}, capacity=#{capacity}, config_path=#{config_path}, dry-run=#{dry_run}..."

    if dry_run
      msg.send util.inspect(params, false, null)
      return

    aws = require('../../aws.coffee').aws()
    autoscaling = new aws.AutoScaling({apiVersion: '2011-01-01'})

    autoscaling.createAutoScalingGroup params, (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        msg.send util.inspect(res, false, null)
