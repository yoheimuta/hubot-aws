# Description:
#   Create ec2 ami
#
# Configurations:
#   HUBOT_AWS_EC2_CREATE_AMI_CONFIG: [optional] Path to csonfile to be performs service operation based on. Required config_path argument or this.
#
# Commands:
#   hubot ec2 ami create --instance_id=*** - Create an ami.
#
# Notes:
#   --instance_id=*** : [required] Target instance id.
#   --name=***        : [optional] Ami name to be created. If omit it, the Name of config is used.
#   --config_path=*** : [optional] Config file path. If omit it, HUBOT_AWS_EC2_CREATE_AMI_CONFIG is referred to.
#   --dry-run         : [optional] Checks whether the api request is right. Recommend to set before applying to real asset.

fs   = require 'fs'
cson = require 'cson'
util = require 'util'

getArgParams = (arg) ->
  dry_run = if arg.match(/--dry-run/) then true else false

  ins_id_capture = /--instance_id=(.*?)( |$)/.exec(arg)
  ins_id = if ins_id_capture then ins_id_capture[1] else null

  name_capture = /--name=(.*?)( |$)/.exec(arg)
  name = if name_capture then name_capture[1] else null

  config_path_capture = /--config_path=(.*?)( |$)/.exec(arg)
  config_path = if config_path_capture then config_path_capture[1] else null

  return {dry_run: dry_run, ins_id: ins_id, name: name, config_path: config_path}

module.exports = (robot) ->
  robot.respond /ec2 ami create(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    arg_params = getArgParams(msg.match[1])

    ins_id      = arg_params.ins_id
    name        = arg_params.name
    config_path = arg_params.config_path
    dry_run     = arg_params.dry_run

    config_path ||= process.env.HUBOT_AWS_EC2_CREATE_AMI_CONFIG
    unless fs.existsSync config_path
      msg.send "NOT FOUND HUBOT_AWS_EC2_CREATE_AMI_CONFIG"
      return

    msg.send "Requesting instance_id=#{ins_id}, name=#{name}, config_path=#{config_path}, dry-run=#{dry_run}..."

    params = cson.parseCSONFile config_path

    params.InstanceId = ins_id if ins_id
    params.Name = name if name

    if dry_run
      msg.send util.inspect(params, false, null)
      return

    aws = require('../../aws.coffee').aws()
    ec2 = new aws.EC2({apiVersion: '2014-10-01'})

    ec2.createImage params, (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        msg.send "Success to create AMI: ami_id=#{res.ImageId}"

