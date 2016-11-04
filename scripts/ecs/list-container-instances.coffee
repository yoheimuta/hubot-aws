listContainerInstances = (msg, params) ->
  aws = require('../../aws.coffee').aws()
  ecs = new aws.ECS()
  ecs.listContainerInstances params, (err, data) ->
    if err
      err
    else
      instances = JSON.parse(data)
      if instances.nextToken
        params.nextToken = instances.nextToken
      instances

module.exports = (robot) ->
  robot.hear /ecs list container instances (.*)$/i, (msg) ->
    params = msg.match[1] || {}
    instances = listContainerInstances(msg, params)
    for instance in instances["containerInstanceArns"]
      msg.send instance