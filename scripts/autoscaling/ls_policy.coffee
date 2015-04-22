# Description:
#   List autoscaling policies
#
# Commands:
#   hubot autoscaling policy ls - Displays all AutoScaling Policies
#   hubot autoscaling policy ls --group_name=[group_name] - Details an Autoscaling Policy

util   = require 'util'
async  = require 'async'
moment = require 'moment'
_      = require 'underscore'

module.exports = (robot) ->
  robot.respond /autoscaling policy ls($| --group_name=)(.*)$/i, (msg) ->
    group_name = msg.match[2].trim() || ''

    msg.send "Fetching #{group_name}..."

    aws = require('../../aws.coffee').aws()
    autoscaling = new aws.AutoScaling({apiVersion: '2011-01-01'})

    autoscaling.describePolicies (if group_name then { AutoScalingGroupName: group_name } else null), (err, res)->
      if err
        msg.send "Error: #{err}"
      else
        if group_name
          msg.send util.inspect(res, false, null)
        else
          msg.send "name\ttype\tadjustment\tcooldown\tgroup_name"
          msg.send "\ttime\tnamespace\tmetric\tstatistic\tthreshold\tperiod\toperator\talarm_name"
          msg.send Array(130).join('-')
          msg.send Array(130).join('-')

          messages = []

          res.ScalingPolicies.sort (a, b) ->
            return -1 if a.AutoScalingGroupName < b.AutoScalingGroupName
            return  1 if a.AutoScalingGroupName > b.AutoScalingGroupName
            return  0

          async.eachSeries res.ScalingPolicies, (conf, next) ->
            name       = conf.PolicyName
            type       = conf.AdjustmentType
            adjustment = conf.ScalingAdjustment
            cooldown   = conf.Cooldown || '[NoValue]'
            group_name = conf.AutoScalingGroupName

            messages.push("\n#{name}\t#{type}\t#{adjustment}\t#{cooldown}\t#{group_name}")

            cloudwatch = new aws.CloudWatch({apiVersion: '2010-08-01'})
            for alarm in conf.Alarms
              cloudwatch.describeAlarms { AlarmNames: [alarm.AlarmName] }, (err, res)->
                if err
                  msg.send "DescribeAlarm: #{err}"
                else
                  res.MetricAlarms.sort (a, b) ->
                    moment(a.AlarmConfigurationUpdatedTimestamp) - moment(b.AlarmConfigurationUpdatedTimestamp)

                  for alarm in res.MetricAlarms
                    time       = moment(alarm.AlarmalarmigurationUpdatedTimestamp).format('YYYY-MM-DD HH:mm:ssZ') || '[NoTime]'
                    alarm_name = alarm.AlarmName
                    namespace  = alarm.Namespace
                    metric     = alarm.MetricName
                    statistic  = alarm.Statistic
                    threshold  = alarm.Threshold
                    period     = alarm.Period
                    operator   = alarm.ComparisonOperator

                    messages.push("\t#{time}\t#{namespace}\t#{metric}\t#{statistic}\t#{threshold}\t#{period}\t#{operator}\t#{alarm_name}")
                # TODO: wait to complete multi alarm loop
                next()

            next() if conf.Alarms.length == 0

          , (err) ->
              if err
                msg.send "async.each Error: #{err}"
              else
                message   = messages.join "\n"
                message ||= '[None]'
                msg.send message
