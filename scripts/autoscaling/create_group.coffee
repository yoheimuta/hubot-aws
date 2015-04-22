# Description:
#   Create autoscaling group
#
# Commands:
#   hubot autoscaling create --name=[group_name] --launch_name=[launch_configuration_name] --dry-run - Try creating an AutoScaling Group
#   hubot autoscaling create --name=[group_name] --launch_name=[launch_configuration_name] - Create an AutoScaling Group

fs   = require 'fs'
cson = require 'cson'
util = require 'util'

module.exports = (robot) ->
  robot.respond /autoscaling create --name=(.*) --launch_name=(.*?)(| --dry-run)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    name = msg.match[1].trim()
    conf = msg.match[2].trim()
    dry_run = if msg.match[3] then true else false

    msg.send "Requesting name=#{name}, launch_name=#{conf}, dry-run=#{dry_run}..."

    params = cson.parseCSONFile process.env.HUBOT_AWS_AS_GROUP_CONFIG
    params.AutoScalingGroupName    = name
    params.LaunchConfigurationName = conf

    if dry_run
      msg.send util.inspect(params, false, null)
      return

    aws = require('../../aws.coffee').aws()
    autoscaling = new aws.AutoScaling({apiVersion: '2011-01-01'})

    autoscaling.createAutoScalingGroup params, (err, res)->
      if err
        msg.send "Error: #{err}"
      else
        msg.send util.inspect(res, false, null)
