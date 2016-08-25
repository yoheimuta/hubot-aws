# Description:
#   Release elastic IP's
#
# Commands:
#   hubot ec2 release address {eipalloc-id}
#   hubot ec2 release address {publicIp}

aws = require('../../aws').aws()
ec2 = new aws.EC2()

module.exports = (robot) ->
  robot.respond /ec2 release address (.*)$/i, (msg) ->
    params = {}
    # we got an IP address as an argument
    if msg.match[1].split('.').length == 4
      params.PublicIp = msg.match[1]
    # we got eipalloc id argument
    else if msg.match[1].match(/^eipalloc-[a-zA-Z0-9].*/i)
      params.AllocationId = msg.match[1]
    else
      return msg.send 'I need the Public IP or allocation ID (eipalloc-xxx) to release an elastic IP.'

    ec2.releaseAddress params, (err, response) ->
      if(err)
        msg.send err
      else
        msg.send "Successfully released #{msg.match[1]}"
        msg.send response
