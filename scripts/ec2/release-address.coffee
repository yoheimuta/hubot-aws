# Description:
#   List elastic IP's
#
# Commands:
#   hubot ec2 describe-addresses

{aws} = require('../aws')
{ec2} = new aws.EC2()

module.exports = (robot) ->
  robot.respond /ec2 release address (.*)$/i, (msg) ->
    params = {
      AllocationId: msg.match[1]
    }
    ec2.releaseAddress params, (response) ->
      msg.send response
