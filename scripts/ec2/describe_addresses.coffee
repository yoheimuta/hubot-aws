# Description:
#   List elastic IP's
#
# Commands:
#   hubot ec2 describe addresses

aws = require('../../aws').aws()
ec2 = new aws.EC2()

module.exports = (robot) ->
  robot.respond /ec2 describe addresses$/i, (msg) ->
    msg.send "Fetching ..."
    ec2.describeAddresses {}, (err,response) ->
      if err
        msg.send err
      else
        keys = Object.keys(response.Addresses[0])
        msg.send keys.join(" | ")
        for eip in response.Addresses
          row = ""
          for key in keys
            if eip[key] == undefined
              row += "UNASSOCIATED  | "
            else
              row += eip[key] + " | "
          msg.send row
