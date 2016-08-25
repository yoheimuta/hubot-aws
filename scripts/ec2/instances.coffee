# Description:
#   start a stopped ec2 instance
#
# Configurations:
#   HUBOT_AWS_EC2_RUN_CONFIG: [optional] Path to csonfile to be performs service operation based on. Required a config_path argument or this.
#   HUBOT_AWS_EC2_RUN_USERDATA_PATH: [optional] Path to userdata file.
#
# Commands:
#   hubot ec2 start #{instance-id} - Start an Instance
#   hubot ec2 stop #{instance-id} - Stop an Instance
#   hubot ec2 reboot #{instance-id} - Reboot an Instance
#   hubot ec2 restart #{instance-id} - Reboot an Instance
#   hubot ec2 terminate #{instance-id} - Terminate an Instance
#
# Notes:
# {instance-id} accepts comma separated list of instance ID's

module.exports = (robot) ->
  robot.respond /ec2 (.*) instances (.*)$/i, (msg) ->
    instanceCommand = msg.match[1];
    instanceIdArgs = msg.match[2];
    if(instanceIdArgs.match(','))
      args = instanceIdArgs.split(',')
    else
      args = instanceIdArgs
    aws = require('../../aws.coffee').aws()
    ec2 = new aws.EC2({apiVersion: '2014-10-01'})
    #lets see if the instance(s) exist(s)
    ec2.describeInstances {instanceIds: args}, (err, response) =>
      if (err)
        msg.send err
      else
        instances = response.Reservations[0].Instances;
        switch instanceCommand
          when "start"
            msg.send "Starting #{args}"
            ec2.startInstances {instanceIds: args}, (err, starting) =>
              if (err)
                msg.send err
              else
                msg.send starting
          when "stop"
            msg.send "Stopping #{args}"
            ec2.stopInstances {instanceIds: args}, (err, stopping) =>
              if (err)
                msg.send err
              else
                msg.send stopping
          when "terminate"
            msg.send "Killing #{args}"
            ec2.terminateInstances {instanceIds: args}, (err, terminating) =>
              if (err)
                msg.send err
              else
                msg.send terminating
          when "reboot" or "restart"
            msg.send "Starting #{args}"
            ec2.rebootInstances {instanceIds: args}, (err, starting) =>
              if (err)
                msg.send err
              else
                msg.send starting
          else
            msg.send "I didn't understand. Did you want me to start, stop, or reboot an instance?"
