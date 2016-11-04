module.exports = (robot) ->
  robot.hear /ecs list services (.*)$/i, (msg) ->
    aws = require('../../aws.coffee').aws()
    ecs = new aws.ECS()
    params = msg.match[1] || {}
    ecs.listServices params, (err, data) ->
      if err
        msg.send err
      else
        services = JSON.parse(data)
        msg.send services