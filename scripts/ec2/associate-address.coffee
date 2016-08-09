# Description:
#   List elastic IP's
#
# Commands:
#   hubot ec2 describe-addresses

{aws} = require('../aws')
{ec2} = new aws.EC2()

#instance-id
#public-ip
#eip-id

module.exports = (robot) ->
  robot.respond /ec2 associate ip (.*) to instance (.*)/i, (msg) ->
    params = {
      PublicIP: msg.match[1],
      InstanceId: msg.match[2]
    }
    ec2.releaseAddress params, (response) ->
      msg.send response

  robot.respond /ec2 associate (.*) to instance (.*)/i, (msg) ->
    params = {
      AllocationId: msg.match[1],
      InstanceId: msg.match[2]
    }
    ec2.releaseAddress params, (response) ->
      msg.send response
