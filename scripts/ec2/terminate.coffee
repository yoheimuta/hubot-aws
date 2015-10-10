# Description:
#   Terminate ec2 instance
#
# Commands:
#   hubot ec2 terminate --instance_id=[instance_id] - Terminate the Instance
#
# Notes:
#   --instance_id=***   : [required] One instance ID.
#   --dry-run           : [optional] Checks whether the api request is right. Recommend to set before applying to real asset.

getArgParams = (arg) ->
  dry_run = if arg.match(/--dry-run/) then true else false

  ins_id_capture = /--instance_id=(.*?)( |$)/.exec(arg)
  ins_id = if ins_id_capture then ins_id_capture[1] else null

  return {dry_run: dry_run, ins_id: ins_id}

module.exports = (robot) ->
  robot.respond /ec2 terminate(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    arg_params = getArgParams(msg.match[1])
    ins_id  = arg_params.ins_id
    dry_run = arg_params.dry_run

    msg.send "Terminating instance_id=#{ins_id}, dry-run=#{dry_run}..."

    aws = require('../../aws.coffee').aws()
    ec2 = new aws.EC2({apiVersion: '2014-10-01'})

    ec2.terminateInstances { DryRun: dry_run, InstanceIds: [ins_id] }, (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        messages = []
        for ins in res.TerminatingInstances
          id     = ins.InstanceId
          state  = ins.CurrentState.Name

          messages.push("#{id}\t#{state}")

        messages.sort()
        message = messages.join "\n"
        msg.send message
