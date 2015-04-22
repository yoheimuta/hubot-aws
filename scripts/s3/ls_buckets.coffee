# Description:
#   List s3 buckets info
#
# Commands:
#   hubot s3 ls - Displays all S3 buckets

moment = require 'moment'
tsv    = require 'tsv'

module.exports = (robot) ->
  robot.respond /s3 ls$/i, (msg) ->
    msg.send "Fetching ..."

    aws = require('../../aws.coffee').aws()
    s3  = new aws.S3({apiVersion: '2006-03-01'})

    s3.listBuckets (err, res)->
      if err
        msg.send "Error: #{err}"
      else
        messages = []
        for bucket in res.Buckets
          messages.push({
            time: moment(bucket.CreationDate).format('YYYY-MM-DD HH:mm:ssZ')
            name: bucket.Name
          })

        messages.sort (a, b) ->
            moment(a.time) - moment(b.time)
        message = tsv.stringify(messages) || '[None]'
        msg.send message
