# Description:
#   Lists users of an iam group
#
# Commands:
#   hubot iam list users in group --groupname=***

# Notes:
#   --groupname=*** : [required] The iam groupname.

getArgParams = (arg) ->
  groupname_capture = /--groupname=(.*?)( |$)/.exec(arg)
  groupname = if groupname_capture then groupname_capture[1] else ''

  return {
    groupname: groupname
  }

module.exports = (robot) ->
  robot.respond /iam list users in group(.*)$/i, (msg) ->
    arg_params = getArgParams(msg.match[1])
    groupname = arg_params.groupname

    msg.send "Listing users in group #{groupname}"

    params = {
      GroupName: groupname
    }

    require('./lib_user_group.coffee').listUsersInGroup(params, msg)
