# Description:
#   Delete a cloudwatch alarm
#
# Commands:
#   hubot cloudwatch alarm delete --name=[alarm_name] - Delete the Alarm
#
util = require 'util'

module.exports = (robot) ->
  robot.respond /cloudwatch alarm delete --name=(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    alarm_name = msg.match[1]

    msg.send "Deleting #{alarm_name}..."

    aws = require('../../aws.coffee').aws()
    cloudwatch = new aws.CloudWatch({apiVersion: '2010-08-01'})

    cloudwatch.deleteAlarms { AlarmNames: [alarm_name] }, (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        msg.send util.inspect(res, false, null)

