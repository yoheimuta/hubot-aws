# Description:
#   List s3 objects info
#
# Commands:
#   hubot s3 ls --bucket_name=[bucket-name] - Displays all objects
#   hubot s3 ls --bucket_name=[bucket-name] --prefix=[prefix] - Displays all objects with prefix
#   hubot s3 ls --bucket_name=[bucket-name] --prefix=[prefix] --marker=[marker] - Displays all objects with prefix from marker

moment = require 'moment'
util   = require 'util'
tsv    = require 'tsv'
_      = require 'underscore'

module.exports = (robot) ->
  robot.respond /s3 ls --bucket_name=(.*?)($| --prefix=)(.*?)($| --marker=)(.*)$/i, (msg) ->
    bucket = msg.match[1].trim()
    prefix = msg.match[3].trim()
    marker = msg.match[5].trim()

    msg.send "Fetching #{bucket}, #{prefix}, #{marker}..."

    aws = require('../../aws.coffee').aws()
    s3  = new aws.S3({apiVersion: '2006-03-01'})

    s3.listObjects { Bucket: bucket, Delimiter: '/', Prefix: prefix, Marker: marker }, (err, res) ->
      if err
        msg.send "Error: #{err}"
      else
        messages = []
        for content in res.Contents
          messages.push({
            Key: content.Key
          })

        message = tsv.stringify(messages)
        msg.send message

        prefix_msgs = []
        for p in res.CommonPrefixes
          prefix_msgs.push({
            Prefix: p.Prefix
          })

        prefix_msg = tsv.stringify(prefix_msgs)
        msg.send prefix_msg

        msg.send "NextMacker is #{res.NextMarker}" || 'NextMarker is none'
