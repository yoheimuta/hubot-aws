# Description:
#   Delete ec2 security groups
#
# Commands:
#   hubot ec2 sg delete --group_id=[group_id] - Delete the SecurityGroup

util = require 'util'

module.exports = (robot) ->
  robot.respond /ec2 sg delete --group_id=(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    group_id = msg.match[1].trim() || ''

    msg.send "Deleting group_id=#{group_id}..."

    aws = require('../../aws.coffee').aws()
    ec2 = new aws.EC2({apiVersion: '2014-10-01'})

    ec2.deleteSecurityGroup { GroupId: group_id }, (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        msg.send "Success to delete sg"
        msg.send util.inspect(res, false, null)

