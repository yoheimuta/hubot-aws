module.exports = {
  addUserToGroup: (params,msg) ->
    aws = require('../../aws.coffee').aws()
    iam = new aws.IAM({apiVersion: '2010-05-08'})
    iam.addUserToGroup params, (err, data) ->
      if err
        msg.send "Error #{err.stack.split('\n')[0]}"
      else
        msg.send "Success"
}
