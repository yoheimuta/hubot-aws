# Description:
#   Run ec2 instance
#
# Configurations:
#   HUBOT_AWS_EC2_RUN_CONFIG: [optional] Path to csonfile to be performs service operation based on. Required a config_path argument or this.
#   HUBOT_AWS_EC2_RUN_USERDATA_PATH: [optional] Path to userdata file.
#
# Commands:
#   hubot ec2 run - Run an Instance
#
# Notes:
#   --image_id=***      : [optional] The ID of the AMI. If omit it, the ImageId of config is used
#   --config_path=***   : [optional] Config file path. If omit it, HUBOT_AWS_EC2_RUN_CONFIG is referred to.
#   --userdata_path=*** : [optional] Userdata file path to be not encoded yet. If omit it, HUBOT_AWS_EC2_RUN_USERDATA_PATH is referred to.
#   --dry-run           : [optional] Checks whether the api request is right. Recommend to set before applying to real asset.

fs   = require 'fs'
cson = require 'cson'
util = require 'util'

getArgParams = (arg) ->
  dry_run = if arg.match(/--dry-run/) then true else false

  image_id_capture = /--image_id=(.*?)( |$)/.exec(arg)
  image_id = if image_id_capture then image_id_capture[1] else null

  config_path_capture = /--config_path=(.*?)( |$)/.exec(arg)
  config_path = if config_path_capture then config_path_capture[1] else null

  userdata_path_capture = /--userdata_path=(.*?)( |$)/.exec(arg)
  userdata_path = if userdata_path_capture then userdata_path_capture[1] else null

  return {dry_run: dry_run, image_id: image_id, config_path: config_path, userdata_path: userdata_path}

module.exports = (robot) ->
  robot.respond /ec2 run(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    arg_params = getArgParams(msg.match[1])

    dry_run       = arg_params.dry_run
    image_id      = arg_params.image_id
    config_path   = arg_params.config_path
    userdata_path = arg_params.userdata_path

    config_path ||= process.env.HUBOT_AWS_EC2_RUN_CONFIG
    unless fs.existsSync config_path
      msg.send "NOT FOUND HUBOT_AWS_EC2_RUN_CONFIG"
      return

    params = cson.parseCSONFile config_path

    params.ImageId = image_id if image_id

    userdata_path ||= process.env.HUBOT_AWS_EC2_RUN_USERDATA_PATH
    if fs.existsSync userdata_path
      init_file = fs.readFileSync userdata_path, 'utf-8'
      params.UserData = new Buffer(init_file).toString('base64')

    msg.send "Requesting image_id=#{image_id}, config_path=#{config_path}, userdata_path=#{userdata_path}, dry-run=#{dry_run}..."

    if dry_run
      msg.send util.inspect(params, false, null)
      return

    aws = require('../../aws.coffee').aws()
    ec2 = new aws.EC2({apiVersion: '2014-10-01'})

    ec2.runInstances params, (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        messages = []
        for ins in res.Instances
          state = ins.State.Name
          id    = ins.InstanceId
          type  = ins.InstanceType
          for network in ins.NetworkInterfaces
            ip  = network.PrivateIpAddress
          for tag in ins.Tags when tag.Key is 'Name'
            name = tag.Value || '[NoName]'

          messages.push("#{state}\t#{id}\t#{type}\t#{ip}\t#{name}")

        messages.sort()
        message = messages.join "\n"
        msg.send message

