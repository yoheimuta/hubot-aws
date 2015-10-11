# Description:
#   Describes one or more of the tags for your EC2 resources
#
# Commands:
#   hubot ec2 tag ls - Desplays all tags
#
# Notes:
#   --resource_type=*** : [optional] Filters the tags by the resource type.
#   --resource_id=***   : [optional] Filters the tags by the resource ID.
#   --key=***           : [optional] Filters the tags by the tag key.
#   --value=***         : [optional] Filters the tags by the tab value.
#   --max_results=***   : [optional] The maximum number of results to return for the request in a single page. This value can be between 5 and 1000.

moment = require 'moment'
tsv    = require 'tsv'

getArgParams = (arg) ->
  resource_type_capture = /--resource_type=(.*?)( |$)/.exec(arg)
  resource_type = if resource_type_capture then resource_type_capture[1] else null

  resource_id_capture = /--resource_id=(.*?)( |$)/.exec(arg)
  resource_id = if resource_id_capture then resource_id_capture[1] else null

  key_capture = /--key=(.*?)( |$)/.exec(arg)
  key = if key_capture then key_capture[1] else null

  value_capture = /--value=(.*?)( |$)/.exec(arg)
  value = if value_capture then value_capture[1] else null

  max_results_capture = /--max_results=(.*?)( |$)/.exec(arg)
  max_results = if max_results_capture then max_results_capture[1] else null

  return {resource_type: resource_type, resource_id: resource_id, key: key, value: value, max_results: max_results}

module.exports = (robot) ->
  robot.respond /ec2 tag ls(.*)$/i, (msg) ->
    msg.send "Fetching ..."

    aws = require('../../aws.coffee').aws()
    ec2 = new aws.EC2({apiVersion: '2014-10-01'})

    arg_params   = getArgParams(msg.match[1])

    resource_type = arg_params.resource_type
    resource_id   = arg_params.resource_id
    key          = arg_params.key
    value        = arg_params.value
    max_results  = arg_params.max_results

    filters = []
    filters.push({Name: "resource-type", Values:[resource_type]}) if resource_type
    filters.push({Name: "resource-id", Values:[resource_id]}) if resource_id
    filters.push({Name: "key", Values:[key]}) if key
    filters.push({Name: "value", Values:[value]}) if value

    params = {}
    params.Filters = filters if 0 < filters.length
    params.MaxResults = max_results if max_results

    ec2.describeTags params, (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        messages = []
        for data in res.Tags

          messages.push({
            resource_type : data.ResourceType
            resource_id   : data.ResourceId
            key           : data.Key
            value         : data.Value
          })

        messages.sort (a, b) ->
          if a.resource_type < b.resource_type then return -1
          if b.resource_type < a.resource_type then return 1
          return 0
        message = tsv.stringify(messages) || '[None]'
        msg.send message
