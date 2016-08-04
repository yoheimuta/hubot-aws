https = require('https')
crypto = require('crypto')
{inspect} = require('util')

certificateCache = {}

downloadCertificate = (url, cb) ->
  if url is undefined
    return cb new Error("Certificate URL not specified")

  if url in certificateCache
    return cb null, certificateCache[url]

  req = https.get url, (res) ->
    chunks = []

    res.on 'data', (chunk) ->
      chunks.push(chunk)
    res.on 'end', ->
      certificateCache[url] = chunks.join('')
      return cb null, certificateCache[url]

  req.on 'error', (error) ->
    return cb new Error('Certificate download failed: ' + error)

signatureStringOrder =
  'Notification': ['Message', 'MessageId', 'Subject', 'Timestamp', 'TopicArn', 'Type'],
  'SubscriptionConfirmation': ['Message', 'MessageId', 'SubscribeURL', 'Timestamp', 'Token', 'TopicArn', 'Type'],
  'UnsubscribeConfirmation': ['Message', 'MessageId', 'SubscribeURL', 'Timestamp', 'Token', 'TopicArn', 'Type']

createSignatureString = (msg) ->
  chunks = []
  for field in signatureStringOrder[msg.Type]
    if field of msg
      chunks.push field
      chunks.push msg[field]
  return chunks.join('\n') + '\n'

verifySignature = (msg, cb) ->
  if msg.SignatureVersion isnt '1'
    return cb new Error("SignatureVersion '#{msg.SignatureVersion}' not supported.")

  downloadCertificate msg.SigningCertURL, (error, pem) ->
    if error
      return cb error

    signatureString = createSignatureString msg

    try
      verifier = crypto.createVerify('RSA-SHA1')
      verifier.update(signatureString, 'utf8')
      if not verifier.verify(pem, msg.Signature, 'base64')
        return cb new Error('Signature verification failed')
    catch error
      return cb new Error('Signature verification failed: ' + error)

    return cb null

exports.verifySignature = verifySignature
