# Description:
#   Create autoscaling launch configurations
#
# Commands:
#   hubot autoscaling launch create --name=[launch_configuration_name] --dry-run - Try creating an AutoScaling LaunchConfiguration
#   hubot autoscaling launch create --name=[launch_configuration_name] - Create an AutoScaling LaunchConfiguration
#   hubot autoscaling launch create --name=[launch_configuration_name] --image_id=[ami-id] --dry-run - Try creating an AutoScaling LaunchConfiguration with image_id
#   hubot autoscaling launch create --name=[launch_configuration_name] --image_id=[ami-id] - Create an AutoScaling LaunchConfiguration with image_id

fs   = require 'fs'
cson = require 'cson'
util = require 'util'

get_arg_params = (arg) ->
    dry_run = if arg.match(/--dry-run/) then true else false

    name_capture = /--name=(.*?)( |$)/.exec(arg)
    name = if name_capture then name_capture[1] else null

    image_id_capture = /--image_id=(.*?)( |$)/.exec(arg)
    image_id = if image_id_capture then image_id_capture[1] else null

    return { dry_run : dry_run, name: name, image_id: image_id }

module.exports = (robot) ->
  robot.respond /autoscaling launch create(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    arg_params = get_arg_params(msg.match[1])

    dry_run    = arg_params.dry_run
    name       = arg_params.name
    image_id   = arg_params.image_id

    msg.send "Requesting name=#{name}, image_id=#{image_id}, dry-run=#{dry_run}..."

    launch_configuration_path  = process.env.HUBOT_AWS_AS_LAUNCH_CONF_CONFIG
    unless fs.existsSync launch_configuration_path
      msg.send "NOT FOUND HUBOT_AWS_AS_LAUNCH_CONF_CONFIG"
      return

    params = cson.parseCSONFile launch_configuration_path

    params.LaunchConfigurationName = name
    params.ImageId = image_id if image_id

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
