# Description:
#   List autoscaling scheduled actions
#
# Commands:
#   hubot autoscaling schedule ls - Displays all AutoScaling Scheduled Actions
#   hubot autoscaling schedule ls --group_name=[group_name] - Details an Autoscaling Scheduled Actions

util   = require 'util'
tsv    = require 'tsv'
moment = require 'moment'

getArgParams = (arg) ->
  group_name_capture = /--group_name=(.*?)( |$)/.exec(arg)
  group_name = if group_name_capture then group_name_capture[1] else ''

  return {group_name: group_name}

module.exports = (robot) ->
  robot.respond /autoscaling schedule ls(.*)$/i, (msg) ->
    arg_params = getArgParams(msg.match[1])
    group_name = arg_params.group_name

    msg.send "Fetching #{group_name || 'all (group_name is not provided)'}..."

    aws = require('../../aws.coffee').aws()
    autoscaling = new aws.AutoScaling({apiVersion: '2011-01-01'})

    autoscaling.describeScheduledActions (if group_name then { AutoScalingGroupName: group_name } else null), (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        if group_name
          msg.send util.inspect(res, false, null)
        else
          messages = []
          res.ScheduledUpdateGroupActions.sort (a, b) ->
            return -1 if a.AutoScalingGroupName < b.AutoScalingGroupName
            return  1 if a.AutoScalingGroupName > b.AutoScalingGroupName
            return  0

          for conf in res.ScheduledUpdateGroupActions
            messages.push({
              group_name       : conf.AutoScalingGroupName
              schedule_name    : conf.ScheduledActionName
              schedule_arn     : conf.ScheduledActionARN
              start_time       : moment(conf.StartTime).format('YYYY-MM-DD HH:mm:ssZ')
              end_time         : if conf.EndTime then moment(conf.EndTime).format('YYYY-MM-DD HH:mm:ssZ') else null
              recurrence       : conf.Recurrence
              min_size         : conf.MinSize
              max_size         : conf.MaxSize
              desired_capacity : conf.DesiredCapacity
            })

          messages.sort (a, b) ->
            moment(a.start_time) - moment(b.start_time)

          message = tsv.stringify(messages) || '[None]'
          msg.send message

