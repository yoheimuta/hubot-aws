addUserToGroup = (params,msg) ->
  aws = require('../../aws.coffee').aws()
  iam = new aws.IAM({apiVersion: '2010-05-08'})
  iam.addUserToGroup params, (err, data) ->
    if err
      msg.send "Error #{err.stack.split('\n')[0]}"
    else
      msg.send "Success"

removeUserFromGroup  = (params,msg) ->
  aws = require('../../aws.coffee').aws()
  iam = new aws.IAM({apiVersion: '2010-05-08'})
  iam.removeUserFromGroup params, (err, data) ->
    if err
      msg.send "Error #{err.stack.split('\n')[0]}"
    else
      msg.send "Success"

listUsersInGroup = (params,msg) ->
  aws = require('../../aws.coffee').aws()
  iam = new aws.IAM({apiVersion: '2010-05-08'})
  iam.getGroup params, (err, data) ->
    if err
      msg.send "Error #{err.stack.split('\n')[0]}"
    else
      for user in data.Users
        msg.send "#{user.UserName} "

module.exports = {
  addUserToGroup: addUserToGroup,
  removeUserFromGroup: removeUserFromGroup,
  listUsersInGroup: listUsersInGroup
}
