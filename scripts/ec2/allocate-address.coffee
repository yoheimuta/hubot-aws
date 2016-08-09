# Description:
#   List elastic IP's
#
# Commands:
#   hubot ec2 describe-addresses

{aws} = require('../aws')
{ec2} = new aws.EC2()

module.exports = (robot) ->
  robot.respond /ec2 allocate address$/i, (msg) ->
    ec2.allocateAddress {}, (response) ->
      keys = Object.keys(response[0]);
      msg.send keys.join(" | ")
      for eip in response
        for key in keys
          msg.send(eip[key] + " | ")
