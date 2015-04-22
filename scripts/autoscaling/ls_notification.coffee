# Description:
#   List autoscaling notification configuration
#
# Commands:
#   hubot autoscaling notification ls - Displays all AutoScaling NotificationConfigurations
#   hubot autoscaling notification ls --group_name=[group_name] - Details an Autoscaling NotificationConfiguration

util   = require 'util'
tsv    = require 'tsv'

module.exports = (robot) ->
  robot.respond /autoscaling notification ls($| --group_name=)(.*)$/i, (msg) ->
    group_name = msg.match[2].trim() || ''

    msg.send "Fetching #{group_name}..."

    aws = require('../../aws.coffee').aws()
    autoscaling = new aws.AutoScaling({apiVersion: '2011-01-01'})

    autoscaling.describeNotificationConfigurations (if group_name then { AutoScalingGroupNames: [group_name] } else null), (err, res)->
      if err
        msg.send "Error: #{err}"
      else
        if group_name
          msg.send util.inspect(res, false, null)
        else
          messages = []
          res.NotificationConfigurations.sort (a, b) ->
            return -1 if a.AutoScalingGroupName < b.AutoScalingGroupName
            return  1 if a.AutoScalingGroupName > b.AutoScalingGroupName
            return  0

          for conf in res.NotificationConfigurations
            messages.push({
              name      : conf.AutoScalingGroupName
              type      : conf.NotificationType
              topic_arn : conf.TopicARN
            })

          message = tsv.stringify(messages) || '[None]'
          msg.send message

