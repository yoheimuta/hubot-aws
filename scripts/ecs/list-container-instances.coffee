module.exports = (robot) ->
  robot.hear /list container instances (.*)$/i, (msg) ->
    aws = require('../../aws.coffee').aws()
    ecs = new aws.ECS()
    params = msg.params || {}
    ecs.listContainerInstances params, (err, data) ->
      if err
        msg.send err
      else
        clusters = JSON.parse(data)
        for cluster in clusters
          msg.send cluster.split('/')[1];