module.exports = {
  aws: ->
    aws = require 'aws-sdk'
    aws.config.accessKeyId     = process.env.HUBOT_AWS_ACCESS_KEY_ID
    aws.config.secretAccessKey = process.env.HUBOT_AWS_SECRET_ACCESS_KEY
    aws.config.region          = process.env.HUBOT_AWS_REGION
    return aws
}
