# Description:
#   Terminate ec2 instances
#
# Commands:
#   hubot ec2 terminate --instance_id=[instance_id] - Terminate the Instance

module.exports = (robot) ->
  robot.respond /ec2 terminate --instance_id=(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    ins_id = msg.match[1]

    msg.send "Terminating #{ins_id}..."

    aws = require('../../aws.coffee').aws()
    ec2 = new aws.EC2({apiVersion: '2014-10-01'})

    ec2.terminateInstances { DryRun: false, InstanceIds: [ins_id] }, (err, res) ->
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
