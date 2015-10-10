# Description:
#   Delete autoscaling launch configurations
#
# Commands:
#   hubot autoscaling launch delete --name=[launch_configuration_name] - Delete the AutoScaling LaunchConfiguration
#
# Notes:
#   --name=*** : [required] One name of the launch configuration to be deleted.

fs   = require 'fs'
cson = require 'cson'
util = require 'util'

module.exports = (robot) ->
  robot.respond /autoscaling launch delete --name=(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    name = msg.match[1].trim() || ''

    msg.send "Requesting #{name}..."

    aws = require('../../aws.coffee').aws()
    autoscaling = new aws.AutoScaling({apiVersion: '2011-01-01'})

    autoscaling.deleteLaunchConfiguration { LaunchConfigurationName: name }, (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        msg.send util.inspect(res, false, null)

