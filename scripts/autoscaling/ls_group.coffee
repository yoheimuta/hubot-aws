# Description:
#   List autoscaling group
#
# Commands:
#   hubot autoscaling ls - Displays all AutoScaling Groups
#   hubot autoscaling ls --name=[group_name] - Details an Autoscaling Group

moment = require 'moment'
util   = require 'util'

getArgParams = (arg) ->
  name_capture = /--name=(.*?)( |$)/.exec(arg)
  name = if name_capture then name_capture[1] else ''

  return {name: name}

module.exports = (robot) ->
  robot.respond /autoscaling ls(.*)$/i, (msg) ->
    arg_params = getArgParams(msg.match[1])
    arg_name = arg_params.name

    msg.send "Fetching #{arg_name || 'all (name is not provided)'}..."

    aws = require('../../aws.coffee').aws()
    autoscaling = new aws.AutoScaling({apiVersion: '2011-01-01'})

    autoscaling.describeAutoScalingGroups (if arg_name then { AutoScalingGroupNames: [arg_name] } else null), (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        if arg_name
          msg.send util.inspect(res, false, null)
        else
          msg.send "name\tcurrent_size\tdesired_size\tmin_size\tmax_size"

          messages = []

          res.AutoScalingGroups.sort (a, b) ->
            moment(a.CreatedTime) - moment(b.CreatedTime)

          for group in res.AutoScalingGroups
            time         = moment(group.CreatedTime).format('YYYY-MM-DD HH:mm:ssZ')
            name         = group.AutoScalingGroupName
            conf         = group.LaunchConfigurationName
            az           = group.AvailabilityZones.join ","
            elb          = group.LoadBalancerNames.join ","
            min_size     = group.MinSize
            max_size     = group.MaxSize
            desired_size = group.DesiredCapacity
            current_size = group.Instances.length

            messages.push("#{name}\t#{current_size}\t#{desired_size}\t#{min_size}\t#{max_size}")

          message   = messages.join "\n"
          message ||= '[None]'
          msg.send message
