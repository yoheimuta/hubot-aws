# Description:
#   Describes one or more of the images (AMIs, AKIs, and ARIs) available to you
#
# Commands:
#   hubot ec2 ami ls - Desplays all AMI(Images)
#
# Notes:
#   --owner=*** : [optional] Filters the images by the owner. Specify an AWS account ID, amazon, aws-marketplace self. Omitting this option set a default value: self.

moment = require 'moment'
tsv    = require 'tsv'

getArgParams = (arg) ->
  owner_capture = /--owner=(.*?)( |$)/.exec(arg)
  owner = if owner_capture then owner_capture[1] else 'self'

  return {owner: owner}

module.exports = (robot) ->
  robot.respond /ec2 ami ls(.*)$/i, (msg) ->
    msg.send "Fetching ..."

    aws = require('../../aws.coffee').aws()
    ec2 = new aws.EC2({apiVersion: '2014-10-01'})

    arg_params = getArgParams(msg.match[1])
    owner = arg_params.owner

    ec2.describeImages { Owners: [owner] }, (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        messages = []
        for data in res.Images
          name = '[NoName]'
          for tag in data.Tags when tag.Key is 'Name'
            name = tag.Value

          messages.push({
            time       : moment(data.CreationDate).format('YYYY-MM-DD HH:mm:ssZ')
            ami_id     : data.ImageId
            owner      : data.OwnerId
            public     : data.Public
            status     : data.State
            root_device: data.RootDeviceType
            virtualization_type: data.VirtualizationType
            ami_name   : data.Name
            name       : name
          })

        messages.sort (a, b) ->
          moment(a.time) - moment(b.time)
        message = tsv.stringify(messages) || '[None]'
        msg.send message
