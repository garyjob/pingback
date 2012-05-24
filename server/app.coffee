request = require 'request'
libxmljs = require 'libxmljs'
express = require 'express'

app = module.exports = express.createServer()

app.configure ->
  
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'ejs'
  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use app.router
  app.use express.static(__dirname + "/public")

app.post '/', (req, res) ->
  link = req.body.link
  linkedTo = req.body.linkedTo
  doPingBack link, linkedTo, (response)->
    res.send(response)

port = 8877
app.listen port
console.log 'server started on', port

#Do the pingback
doPingBack = (link, linkedTo, callback)->
  payload = getPingPacket(link, linkedTo)
  getPingBackServerUrl linkedTo, (pingBackServer)->
    if(pingBackServer)
      request
          uri: pingBackServer
          method: 'POST'
          contentType: 'text/xml'
          contentLength: payload.length
          body : payload
        ,(err, header, body)->
          xmlDoc = libxmljs.parseXmlString(body)
          responseNode = xmlDoc.get('//string')
          callback(responseNode.text())
    else
      callback('The destination has no pingback server')
  
#Gets the packet to be sent to the ping back server
getPingPacket = (link, linkedTo)->
  payload = '<?xml version="1.0"?><methodCall><methodName>pingback.ping</methodName><params><param><value>'+link+'</value></param><param><value>'+linkedTo+'</value></param></params></methodCall>'
  payload = payload.trim()
  return payload

#Gets the ping back server url
getPingBackServerUrl = (linkedTo, callback)->
  request
    uri:linkedTo
  ,(err, header, body)->
    pingBackServer = header.headers['x-pingback']
    callback(pingBackServer)

    #doPingBack 'http://blog.name1price.com/2012/05/test-3/','https://blog.disconnect.me/fbme',(response)->
    #console.log(response)

