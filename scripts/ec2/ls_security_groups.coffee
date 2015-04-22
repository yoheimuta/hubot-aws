# Description:
#   List ec2 security groups info
#
# Commands:
#   hubot ec2 sg ls - Desplays all SecurityGroups

module.exports = (robot) ->
  robot.respond /ec2 sg ls$/i, (msg) ->
    msg.send "Fetching ..."

    aws = require('../../aws.coffee').aws()
    ec2 = new aws.EC2({apiVersion: '2014-10-01'})

    ec2.describeSecurityGroups null, (err, res)->
      if err
        msg.send "Error: #{err}"
      else
        msg.send "vpc_id\tgroup_id\tgroup_name\tname\tdesc"
        msg.send "\tprotocol\tfrom\tto\trange"
        msg.send Array(130).join('-')
        msg.send Array(130).join('-')

        messages = []

        res.SecurityGroups.sort (a, b) ->
          if a.GroupName < b.GroupName then return -1
          if b.GroupName < a.GroupName then return 1
          return 0

        for sg in res.SecurityGroups
          vpc_id     = sg.VpcId
          group_name = sg.GroupName || '[NoName]'
          group_id   = sg.GroupId
          desc       = sg.Description
          name       = '[NoName]'
          for tag in sg.Tags when tag.Key is 'Name'
            name = tag.Value || '[NoName]'

          messages.push("\n#{vpc_id}\t#{group_id}\t#{group_name}\t#{name}\t#{desc}")

          for inbound in sg.IpPermissions
            protocol = inbound.IpProtocol
            if protocol == '-1' then protocol = 'All traffic'

            from     = inbound.FromPort || 'All'
            to       = inbound.ToPort   || 'All'
            for ipRange in inbound.IpRanges
              range = ipRange.CidrIp
              messages.push("\tInbound \t#{protocol}\t#{from}\t#{to}\t#{range}")

          for outbound in sg.IpPermissionsEgress
            protocol = outbound.IpProtocol
            if protocol == '-1' then protocol = 'All traffic'

            from     = outbound.FromPort || 'All'
            to       = outbound.ToPort   || 'All'
            for ipRange in outbound.IpRanges
              range = ipRange.CidrIp
              messages.push("\tOutbound\t#{protocol}\t#{from}\t#{to}\t#{range}")

        message = messages.join "\n"
        msg.send message
