# Description:
#   Run ec2 instances
#
# Commands:
#   hubot ec2 run --dry-run - Try running an Instance
#   hubot ec2 run - Run an Instance

fs   = require 'fs'
cson = require 'cson'
util = require 'util'

module.exports = (robot) ->
  robot.respond /ec2 run(| --dry-run)$/i, (msg) ->
    unless require('../../auth.coffee').canAccess(robot, msg.envelope.user)
      msg.send "You cannot access this feature. Please contact with admin"
      return

    dry_run = if msg.match[1] then true else false

    msg.send "Requesting dry-run=#{dry_run}..."

    run_configuration_path = process.env.HUBOT_AWS_EC2_RUN_CONFIG
    params = cson.parseCSONFile run_configuration_path

    userdata_path = process.env.HUBOT_AWS_EC2_RUN_USERDATA_PATH
    if fs.existsSync userdata_path
      init_file = fs.readFileSync userdata_path, 'utf-8'
      params.UserData = new Buffer(init_file).toString('base64')

    if dry_run
      msg.send util.inspect(params, false, null)
      return

    aws = require('../../aws.coffee').aws()
    ec2 = new aws.EC2({apiVersion: '2014-10-01'})

    ec2.runInstances params, (err, res)->
      if err
        msg.send "Error: #{err}"
      else
        messages = []
        for ins in res.Instances
          state = ins.State.Name
          id    = ins.InstanceId
          type  = ins.InstanceType
          for network in ins.NetworkInterfaces
            ip  = network.PrivateIpAddress
          for tag in ins.Tags when tag.Key is 'Name'
            name = tag.Value || '[NoName]'

          messages.push("#{state}\t#{id}\t#{type}\t#{ip}\t#{name}")

        messages.sort()
        message = messages.join "\n"
        msg.send message

