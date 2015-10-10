# Description:
#   Create ec2 security groups
#
# Commands:
#   hubot ec2 sg create --group_name=[group_name] --desc=[desc] --vpc_id=[vpc_id] - Create a SecurityGroup
#
# Notes:
#   --group_name=*** : [required] The name of the security group.
#   --desc=***       : [required] A description for the security group.
#   --vpc_id=***     : [optional] [EC2-VPC] The ID of the VPC
#   --dry-run        : [optional] Checks whether the api request is right. Recommend to set before applying to real asset.

util = require 'util'

module.exports = (robot) ->
  robot.respond /ec2 sg create --vpc_id=(.*) --group_name=(.*) --desc=(.*?)(| --dry-run)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    vpc_id     = msg.match[1].trim()
    group_name = msg.match[2].trim()
    desc       = msg.match[3].trim()
    dry_run    = if msg.match[4] then true else false

    msg.send "Requesting vpc_id=#{vpc_id}, group_name=#{group_name}, desc=#{desc}, dry_run=#{dry_run}..."

    params = {
      VpcId       : vpc_id,
      GroupName   : group_name,
      Description : desc,
      DryRun      : dry_run,
    }

    if dry_run
      msg.send util.inspect(params, false, null)
      return

    aws = require('../../aws.coffee').aws()
    ec2 = new aws.EC2({apiVersion: '2014-10-01'})

    ec2.createSecurityGroup params, (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        msg.send "Success to create SecurityGroupId: #{res.GroupId}"
