# Description:
#   Deregisters the specified AMI. After you deregister an AMI, it can't be used to launch new instances.
#
# Commands:
#   hubot ec2 ami deregister --ami_id=[ami_id] - Deregisters the specified AMI
#
# Notes:
#   --ami_id=*** : [required] The ID of the AMI.
#   --dry-run    : [optional] Checks whether the api request is right. Recommend to set before applying to real asset.

util = require 'util'

getArgParams = (arg) ->
  dry_run = if arg.match(/--dry-run/) then true else false

  ami_id_capture = /--ami_id=(.*?)( |$)/.exec(arg)
  ami_id = if ami_id_capture then ami_id_capture[1] else null

  return {dry_run: dry_run, ami_id: ami_id}

module.exports = (robot) ->
  robot.respond /ec2 ami deregister(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    arg_params = getArgParams(msg.match[1])

    ami_id  = arg_params.ami_id
    dry_run = arg_params.dry_run

    msg.send "Deregistering ami_id=#{ami_id}, dry-run=#{dry_run}..."

    aws = require('../../aws.coffee').aws()
    ec2 = new aws.EC2({apiVersion: '2014-10-01'})

    ec2.deregisterImage { ImageId: ami_id, DryRun: dry_run }, (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        msg.send "Success to deregister ami"
        msg.send util.inspect(res, false, null)
