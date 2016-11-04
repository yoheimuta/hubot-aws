# Description:
#  Deletes the specified set of tags from the specified set of resources
#
# Commands:
#   hubot ec2 tag delete --resource_id=*** - Deletes the specified set of tags
#
# Notes:
#   --resource_id=*** : [required] The IDs of one resource to tag. For example, ami-1a2b3c4d.
#   --tag_key=***     : [optional] The key of the tag.
#   --tag_value=***   : [optional] The value of the tag.
#   --dry-run         : [optional] Checks whether the api request is right. Recommend to set before applying to real asset.

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
  robot.respond /ec2 tag delete(.*)$/i, (msg) ->
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

    msg.send "Deleting a tag: resource_id=#{resource_id}, tag_key=#{tag_key}, tag_value=#{tag_value}, dry-run=#{dry_run}..."

    params =
      Resources: [resource_id]
    params.Tags = [ Key: tag_key ] if tag_key
    params.Tags[0].Value = tag_value if params.Tags && 0 < params.Tags.length && tag_value

    if dry_run
      msg.send util.inspect(params, false, null)
      return

    aws = require('../../aws.coffee').aws()
    ec2 = new aws.EC2({apiVersion: '2014-10-01'})

    ec2.deleteTags params, (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        msg.send "Success to delete tags"
        msg.send util.inspect(res, false, null)
