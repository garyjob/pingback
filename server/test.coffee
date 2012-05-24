request = require('request')
fs = require('fs')
libxmljs = require("libxmljs")

myResponse = fs.readFileSync('response.txt')
xmlDoc = libxmljs.parseXmlString(myResponse)
responseNode = xmlDoc.get('//string')
console.log(responseNode.text())
