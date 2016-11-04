module.exports = (robot) ->
  robot.hear /list clusters (.*)$/i, (msg) ->
    aws = require('../../aws.coffee').aws()
    ecs = new aws.ECS()
    params = msg.params || {}
    ecs.listClusters params, (err, data) ->
      if err
        msg.send err
      else
        clusters = JSON.parse(data)["clusterArns"]
        for cluster in clusters
          msg.send cluster.split('/')[1];