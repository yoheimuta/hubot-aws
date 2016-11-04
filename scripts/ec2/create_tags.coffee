# Description:
#   Adds or overwrites one tag for the specified Amazon EC2 resource or resources
#
# Commands:
#   hubot ec2 tag create --resource_id=*** --tag_key=*** --tag_value=*** - Create a tag.
#
# Notes:
#   --resource_id=*** : [required] The IDs of one resource to tag. For example, ami-1a2b3c4d.
#   --tag_key=***     : [required] The key of the tag.
#   --tag_value=***   : [required] The value of the tag.
#   --dry-run         : [optional] Checks whether the api request is right. Recommend to set before applying to real asset.

fs   = require 'fs'
cson = require 'cson'
util = require 'util'

getArgParams = (arg) ->
  dry_run = if arg.match(/--dry-run/) then true else false

  resource_id_capture = /--resource_id=(.*?)( |$)/.exec(arg)
  resource_id = if resource_id_capture then resource_id_capture[1] else null

  tag_key_capture = /--tag_key=(.*?)( |$)/.exec(arg)
  tag_key = if tag_key_capture then tag_key_capture[1] else null

  tag_value_capture = /--tag_value=(.*?)( |$)/.exec(arg)
  tag_value = if tag_value_capture then tag_value_capture[1] else null

  return {dry_run: dry_run, resource_id: resource_id, tag_key: tag_key, tag_value: tag_value}

module.exports = (robot) ->
  robot.respond /ec2 tag create(.*)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact an admin."
      return

    arg_params = getArgParams(msg.match[1])

    resource_id = arg_params.resource_id
    tag_key     = arg_params.tag_key
    tag_value   = arg_params.tag_value
    dry_run     = arg_params.dry_run

    unless resource_id
      msg.send "resource_id option is required"
      return

    unless tag_key
      msg.send "tag_key option is required"
      return

    unless tag_value
      msg.send "tag_value option is required"
      return

    msg.send "Requesting resource_id=#{resource_id}, tag_key=#{tag_key}, tag_value=#{tag_value}, dry-run=#{dry_run}..."

    params =
      Resources: [resource_id]
      Tags: [
        Key: tag_key, Value: tag_value
      ]

    if dry_run
      msg.send util.inspect(params, false, null)
      return

    aws = require('../../aws.coffee').aws()
    ec2 = new aws.EC2({apiVersion: '2014-10-01'})

    ec2.createTags params, (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        msg.send "Success to create a tag"
        msg.send util.inspect(res, false, null)
