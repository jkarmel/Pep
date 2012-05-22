express = require 'express'
coffeekup = require 'coffeekup'

app = express.createServer()

app.configure ->
  app.register '.coffee', require('coffeekup').adapters.express

  # Compile public Coffeescript
  app.use express.compiler
    src: __dirname + '/../public'
    enable: [ 'coffeescript' ]

  app.use express.compiler
    src: __dirname + '/ui_components'
    enable: [ 'coffeescript' ]

  app.use app.router

  # Serve public files statically
  app.use express.static(__dirname + '/../public')
  app.use express.static(__dirname + '/ui_components')

app.configure 'development', ->
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true

app.get '/', (req, res) ->
  res.writeHead 200, 'Content-Type': 'text/html'
  res.write coffeekup.render ->
    doctype 5
    html ->
      head ->
        link rel: "stylesheet", href: "/vendor/mocha.css"
        script src: "https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"
        script src: "/vendor/mocha.js"
        script src: "/vendor/chai.js"

        coffeescript ->
          chai.should()
          mocha.setup("bdd")

        script src: "/javascripts/vendor/require.min.js"
        script src: "/chat.spec.html.js"
        coffeescript ->
          $ ->
            mocha.run().globals ['View', '$$', '$$$']
      body ->
        div "#mocha", ""
  res.end()

port = 1337
app.listen port
console.log 'Express server listening on port %d in %s mode', port, 'development'