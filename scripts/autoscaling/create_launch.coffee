# Description:
#   Create autoscaling launch configuration
#
# Configurations:
#   HUBOT_AWS_AS_LAUNCH_CONF_CONFIG: [optional] Path to csonfile to be performs service operation based on. Required a config_path argument or this.
#   HUBOT_AWS_AS_LAUNCH_CONF_USERDATA_PATH: [optional] Path to csonfile to be performs service operation based on.
#
# Commands:
#   hubot autoscaling launch create - Create an AutoScaling LaunchConfiguration
#
# Notes:
#   --name=***          : [optional] The name of the launch configuration. If omit it, the LaunchConfigurationName of config is used.
#   --image_id=***      : [optional] The ID of the AMI to use to launch your EC2 instances. If omit it, the ImageId of config is used.
#   --config_path=***   : [optional] Config file path. If omit it, HUBOT_AWS_AS_LAUNCH_CONF_CONFIG is referred to.
#   --userdata_path=*** : [optional] Userdata file path to be not encoded yet. If omit it, HUBOT_AWS_AS_LAUNCH_CONF_USERDATA_PATH is referred to.
#   --dry-run           : [optional] Checks whether the api request is right. Recommend to set before applying to real asset.

fs   = require 'fs'
cson = require 'cson'
util = require 'util'

getArgParams = (arg) ->
  dry_run = if arg.match(/--dry-run/) then true else false

  name_capture = /--name=(.*?)( |$)/.exec(arg)
  name = if name_capture then name_capture[1] else null

  image_id_capture = /--image_id=(.*?)( |$)/.exec(arg)
  image_id = if image_id_capture then image_id_capture[1] else null

  config_path_capture = /--config_path=(.*?)( |$)/.exec(arg)
  config_path = if config_path_capture then config_path_capture[1] else null

  userdata_path_capture = /--userdata_path=(.*?)( |$)/.exec(arg)
  userdata_path = if userdata_path_capture then userdata_path_capture[1] else null

  return {dry_run: dry_run, name: name, image_id: image_id, config_path: config_path, userdata_path: userdata_path}

module.exports = (robot) ->
  robot.respond /autoscaling launch create(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact an admin."
      return

    arg_params = getArgParams(msg.match[1])

    dry_run       = arg_params.dry_run
    name          = arg_params.name
    image_id      = arg_params.image_id
    config_path   = arg_params.config_path
    userdata_path = arg_params.userdata_path

    config_path ||= process.env.HUBOT_AWS_AS_LAUNCH_CONF_CONFIG
    unless fs.existsSync config_path
      msg.send "NOT FOUND HUBOT_AWS_AS_LAUNCH_CONF_CONFIG"
      return

    params = cson.parseCSONFile config_path

    params.LaunchConfigurationName = name if name
    params.ImageId = image_id if image_id

    userdata_path ||= process.env.HUBOT_AWS_AS_LAUNCH_CONF_USERDATA_PATH
    if fs.existsSync userdata_path
      init_file = fs.readFileSync userdata_path, 'utf-8'
      params.UserData = new Buffer(init_file).toString('base64')

    msg.send "Requesting name=#{name}, image_id=#{image_id}, config_path=#{config_path}, userdata_path=#{userdata_path}, dry-run=#{dry_run}..."

    if dry_run
      msg.send util.inspect(params, false, null)
      return

    aws = require('../../aws.coffee').aws()
    autoscaling = new aws.AutoScaling({apiVersion: '2011-01-01'})

    autoscaling.createLaunchConfiguration params, (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        msg.send util.inspect(res, false, null)
