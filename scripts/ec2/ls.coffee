# Description:
#   List ec2 instances info
#   Show detail about a instance if specified instance id
#
# Commands:
#   hubot ec2 ls - Displays all Instances
#   hubot ec2 ls --instance_id=[instance_id] - Details an Instance

moment = require 'moment'
util   = require 'util'
tsv    = require 'tsv'

getArgParams = (arg) ->
  ins_id_capture = /--instance_id=(.*?)( |$)/.exec(arg)
  ins_id = if ins_id_capture then ins_id_capture[1] else ''

  return {ins_id: ins_id}

module.exports = (robot) ->
  robot.respond /ec2 ls(.*)$/i, (msg) ->
    arg_params = getArgParams(msg.match[1])
    ins_id  = arg_params.ins_id

    msg.send "Fetching #{ins_id || 'all (instance_id is not provided)'}..."

    aws = require('../../aws.coffee').aws()
    ec2 = new aws.EC2({apiVersion: '2014-10-01'})

    ec2.describeInstances (if ins_id then { InstanceIds: [ins_id] } else null), (err, res) ->
      if err
        msg.send "DescribeInstancesError: #{err}"
      else
        if ins_id
          msg.send util.inspect(res, false, null)

          ec2.describeInstanceAttribute { InstanceId: ins_id, Attribute: 'userData' }, (err, res) ->
            if err
              msg.send "DescribeInstanceAttributeError: #{err}"
            else if res.UserData.Value
              msg.send new Buffer(res.UserData.Value, 'base64').toString('ascii')
        else
          messages = []
          for data in res.Reservations
            ins = data.Instances[0]

            name = '[NoName]'
            for tag in ins.Tags when tag.Key is 'Name'
              name = tag.Value

            messages.push({
              time   : moment(ins.LaunchTime).format('YYYY-MM-DD HH:mm:ssZ')
              state  : ins.State.Name
              id     : ins.InstanceId
              image  : ins.ImageId
              az     : ins.Placement.AvailabilityZone
              subnet : ins.SubnetId
              type   : ins.InstanceType
              ip     : ins.PrivateIpAddress
              name   : name || '[NoName]'
            })

          messages.sort (a, b) ->
            moment(a.time) - moment(b.time)
          message = tsv.stringify(messages) || '[None]'
          msg.send message
