# Description:
#   Create autoscaling launch configurations
#
# Commands:
#   hubot autoscaling launch create --name=[launch_configuration_name] --dry-run - Try creating an AutoScaling LaunchConfiguration
#   hubot autoscaling launch create --name=[launch_configuration_name] - Create an AutoScaling LaunchConfiguration

fs   = require 'fs'
cson = require 'cson'
util = require 'util'

module.exports = (robot) ->
  robot.respond /autoscaling launch create --name=(.*?)(| --dry-run)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    name    = msg.match[1].trim()
    dry_run = if msg.match[2] then true else false

    msg.send "Requesting name=#{name}, dry-run=#{dry_run}..."

    launch_configuration_path  = process.env.HUBOT_AWS_AS_LAUNCH_CONF_CONFIG
    unless fs.existsSync launch_configuration_path
      msg.send "NOT FOUND HUBOT_AWS_AS_LAUNCH_CONF_CONFIG"
      return

    params = cson.parseCSONFile launch_configuration_path

    params.LaunchConfigurationName = name

    userdata_path = process.env.HUBOT_AWS_AS_LAUNCH_CONF_USERDATA_PATH
    if fs.existsSync userdata_path
      init_file = fs.readFileSync userdata_path, 'utf-8'
      params.UserData = new Buffer(init_file).toString('base64')

    if dry_run
      msg.send util.inspect(params, false, null)
      return

    aws = require('../../aws.coffee').aws()
    autoscaling = new aws.AutoScaling({apiVersion: '2011-01-01'})

    autoscaling.createLaunchConfiguration params, (err, res)->
      if err
        msg.send "Error: #{err}"
      else
        msg.send util.inspect(res, false, null)
