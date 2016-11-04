# Description:
#   List elastic IP's
#
# Commands:
#   hubot ec2 describe addresses

module.exports = (robot) ->
  robot.respond /ec2 describe addresses$/i, (msg) ->
    aws = require('../../aws').aws()
    ec2 = new aws.EC2()
    msg.send "Fetching ..."
    ec2.describeAddresses {}, (err,response) ->
      if err
        msg.send err
      else
        for address in response.Addresses
          keys = Object.keys(address)
          msg.send keys.join(" | ")
            for eip in address
              row = ""
              for key in keys
                if eip[key] == undefined
                  row += "UNASSOCIATED  | "
                else
                  row += eip[key] + " | "
              msg.send row
