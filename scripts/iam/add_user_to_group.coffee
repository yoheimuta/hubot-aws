# Description:
#   Adds an iam user to an iam group
#
# Commands:
#   hubot iam add user to group --username=*** --groupname=***

# Notes:
#   --username=***     : [required] The iam username.
#   --groupname=*** : [required] The iam groupname.

getArgParams = (arg) ->
  username_capture = /--username=(.*?)( |$)/.exec(arg)
  username = if username_capture then username_capture[1] else ''

  groupname_capture = /--groupname=(.*?)( |$)/.exec(arg)
  groupname = if groupname_capture then groupname_capture[1] else ''

  return {
    username: username,
    groupname: groupname
  }

module.exports = (robot) ->
  robot.respond /iam add user to group(.*)$/i, (msg) ->
    arg_params = getArgParams(msg.match[1])
    username  = arg_params.username
    groupname = arg_params.groupname

    msg.send "Adding user #{username} to group #{groupname}"

    params = {
      GroupName: groupname,
      UserName: username
    }

    require('./lib_user_group.coffee').addUserToGroup(params, msg)
