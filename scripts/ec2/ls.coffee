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

module.exports = (robot) ->
  robot.respond /ec2 ls($| --instance_id=)(.*)$/i, (msg) ->
    ins_id = msg.match[2].trim() || ''

    msg.send "Fetching #{ins_id}..."

    aws = require('../../aws.coffee').aws()
    ec2 = new aws.EC2({apiVersion: '2014-10-01'})

    ec2.describeInstances (if ins_id then { InstanceIds: [ins_id] } else null), (err, res)->
      if err
        msg.send "DescribeInstancesError: #{err}"
      else
        if ins_id
          msg.send util.inspect(res, false, null)

          ec2.describeInstanceAttribute { InstanceId: ins_id, Attribute: 'userData' }, (err, res)->
            if err
              msg.send "DescribeInstanceAttributeError: #{err}"
            else if res.UserData.Value
              msg.send new Buffer(res.UserData.Value, 'base64').toString('ascii')
        else
          messages = []
          for data in res.Reservations
            ins = data.Instances[0]

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
