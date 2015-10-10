# Description:
#   List cloudwatch alarms
#
# Commands:
#   hubot cloudwatch alarm ls - Displays all Alarms
#   hubot cloudwatch alarm ls --name=[alarm_name] - Details an Alarm

util   = require 'util'
moment = require 'moment'

getArgParams = (arg) ->
  name_capture = /--name=(.*?)( |$)/.exec(arg)
  name = if name_capture then name_capture[1] else ''

  return {name: name}

module.exports = (robot) ->
  robot.respond /cloudwatch alarm ls(.*)$/i, (msg) ->
    arg_params = getArgParams(msg.match[1])
    alarm_name = arg_params.name

    msg.send "Fetching #{alarm_name || 'all (name is not provided)'}..."

    aws = require('../../aws.coffee').aws()
    cloudwatch = new aws.CloudWatch({apiVersion: '2010-08-01'})

    cloudwatch.describeAlarms (if alarm_name then { AlarmNames: [alarm_name] } else null), (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        if alarm_name
          msg.send util.inspect(res, false, null)
        else
          msg.send "time\tnamespace\tmetric\tstatistic\tthreshold\tperiod\toperator\tname"
          msg.send "\tdimension.Name\tdimension.Value"
          msg.send Array(130).join('-')
          msg.send Array(130).join('-')

          messages = []

          res.MetricAlarms.sort (a, b) ->
            moment(a.AlarmConfigurationUpdatedTimestamp) - moment(b.AlarmConfigurationUpdatedTimestamp)

          for conf in res.MetricAlarms
            time      = moment(conf.AlarmConfigurationUpdatedTimestamp).format('YYYY-MM-DD HH:mm:ssZ')
            name      = conf.AlarmName
            namespace = conf.Namespace
            metric    = conf.MetricName
            statistic = conf.Statistic
            threshold = conf.Threshold
            period    = conf.Period
            operator  = conf.ComparisonOperator

            messages.push("#{time}\t#{namespace}\t#{metric}\t#{statistic}\t#{threshold}\t#{period}\t#{operator}\t#{name}")
            for dimension in conf.Dimensions
              messages.push("\t#{dimension.Name}\t#{dimension.Value}")
            messages.push("\n")

          message   = messages.join "\n"
          message ||= '[None]'
          msg.send message

