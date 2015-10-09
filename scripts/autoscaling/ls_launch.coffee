# Description:
#   List autoscaling launch configuration
#
# Commands:
#   hubot autoscaling launch ls - Displays all AutoScaling LaunchConfigurations
#   hubot autoscaling launch ls --name=[launch_configuration_name] - Details an Autoscaling LaunchConfiguration

moment = require 'moment'
util   = require 'util'
tsv    = require 'tsv'

getArgParams = (arg) ->
  name_capture = /--name=(.*?)( |$)/.exec(arg)
  name = if name_capture then name_capture[1] else ''

  return {name: name}

module.exports = (robot) ->
  robot.respond /autoscaling launch ls(.*)$/i, (msg) ->
    arg_params = getArgParams(msg.match[1])
    arg_name = arg_params.name

    msg.send "Fetching #{arg_name||'all (name is not provided)'}..."

    aws = require('../../aws.coffee').aws()
    autoscaling = new aws.AutoScaling({apiVersion: '2011-01-01'})

    autoscaling.describeLaunchConfigurations (if arg_name then { LaunchConfigurationNames: [arg_name] } else null), (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        if arg_name
          msg.send util.inspect(res, false, null)
        else
          messages = []
          for conf in res.LaunchConfigurations
            messages.push({
              time     : moment(conf.CreatedTime).format('YYYY-MM-DD HH:mm:ssZ')
              name     : conf.LaunchConfigurationName
              image    : conf.ImageId
              type     : conf.InstanceType
              price    : conf.SpotPrice || '[NoPrice]'
              security : conf.SecurityGroups.join ","
            })

          messages.sort (a, b) ->
            moment(a.time) - moment(b.time)
          message = tsv.stringify(messages) || '[None]'
          msg.send message
