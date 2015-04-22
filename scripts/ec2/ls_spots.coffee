# Description:
#   List ec2 spot instances info
#
# Commands:
#   hubot ec2 spot ls - Displays all SpotInstances

moment = require "moment"
tsv    = require 'tsv'
async  = require 'async'
_      = require 'underscore'

module.exports = (robot) ->
  robot.respond /ec2 spot ls$/i, (msg) ->
    msg.send "Fetching ..."

    aws = require('../../aws.coffee').aws()
    ec2 = new aws.EC2({apiVersion: '2014-10-01'})

    ec2.describeSpotInstanceRequests null, (err, res)->
      if err
        msg.send "SpotInstanceRequestError: #{err}"
      else
        messages = []

        # eachSeries is safer but slower
        async.eachSeries res.SpotInstanceRequests, (ins, next) ->
          request = {
            time      : moment(ins.Status.UpdateTime).format('YYYY-MM-DD HH:mm:ssZ')
            code      : ins.Status.Code
            id        : ins.InstanceId
            az        : ins.LaunchedAvailabilityZone
            type      : ins.LaunchSpecification.InstanceType
            spotPrice : ins.SpotPrice
          }

          ec2.describeInstances {InstanceIds:[request.id]}, (err, res)->
            if err
              msg.send "DescribeInstancesError: #{err}"
            else
              request.ip = '[NoIP]'
              for data in res.Reservations
                ins        = data.Instances[0]
                request.ip = ins.PrivateIpAddress

            similar_one = _.find messages, (one)-> return (one.type == request.type && one.az == request.az)
            if similar_one
              request.price            = similar_one.price
              request.avg_latest_price = similar_one.avg_latest_price
              messages.push(request)
              next()
              return

            ec2.describeSpotPriceHistory {
              InstanceTypes       : [request.type],
              ProductDescriptions : ['Linux/UNIX'],
              StartTime           : moment().utc().subtract(1, 'hours').toDate(),
              EndTime             : moment().utc().toDate(),
              AvailabilityZone    : request.az
            }, (err, res) ->
              if err
                msg.send "DescribeSpotPriceHistory: #{err}"
              else
                history = res.SpotPriceHistory
                request.price = history[0].SpotPrice

                sum = _.reduce history, (memo, param)->
                  return memo + (+param.SpotPrice)
                , 0

                request.avg_latest_price = (sum / history.length).toFixed(6)

              messages.push(request)
              next()

        , (err) ->
            if err
              msg.send "async Error: #{err}"
            else
              messages.sort (a, b) ->
                  moment(a.time) - moment(b.time)
              message = tsv.stringify(messages)
              msg.send message
