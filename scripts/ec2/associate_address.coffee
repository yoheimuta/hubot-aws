# Description:
#   Associate elastic IP's to an instance, load balancer, etc.
#
# Commands:
#   hubot ec2 associate {publicIp} to {instancId}
#   hubot ec2 associate {AllocationId} to {instanceId}

aws = require('.,/aws').aws()
ec2 = new aws.EC2()

module.exports = (robot) ->

  robot.respond /ec2 associate (.*) to (.*)/i, (msg) ->
    msg.send 'Working on it...'
    params = {
      InstanceId: msg.match[2]
    }
    if msg.match[1].split('.').length == 4
      #you provided hubot an IP address
      params.PublicIp = msg.match[1]
    if msg.match[1].match /eipalloc/i
      #you provided hubot an eipalloc id
      params.AllocationId = msg.match[1]

    if msg.match[2].match(/^i-[a-zA-Z0-9].*/i)
      ec2.describeAddresses {
        AllocationIds: [params.AllocationId]
      }, (err, addresses) ->
        if(err)
          msg.send err
        else
          publicIp = addresses.Addresses[0].PublicIp
          ec2.associateAddress params, (err, response) ->
            if err
              msg.send err
            else
              url = "https://console.aws.amazon.com/ec2/v2/home?region=" + process.env.HUBOT_AWS_REGION + "#Instances:instanceId=" + params.InstanceId + ";sort=desc:tag:Name"
              msg.send "I attached " + publicIp + " to the instance " + params.InstanceId + ". Association Id is " + response.AssociationId + "."
              msg.send url
    else
      msg.send "I'm not sure I understood what you wanted me to do."
