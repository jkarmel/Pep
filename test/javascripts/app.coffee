express = require 'express'
coffeekup = require 'coffeekup'

app = express.createServer()

app.configure ->
  app.register '.coffee', require('coffeekup').adapters.express

  # Compile public Coffeescript
  app.use express.compiler
    src: __dirname + '/resources'
    enable: [ 'coffeescript' ]

  app.use express.compiler
    src: __dirname + '/ui'
    enable: [ 'coffeescript' ]

  app.use express.compiler
    src: __dirname + '/entry_point'
    enable: [ 'coffeescript' ]

  app.use app.router

  # Serve public files statically
  app.use express.static(__dirname + '/resources')
  app.use express.static(__dirname + '/ui')
  app.use express.static(__dirname + '/entry_point')

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
        link rel: "stylesheet", href: "/support/mocha.css"
        script src: "https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"
        script src: "/javascripts/vendor/jquery-ui.custom.min.js"
        script src: "/support/mocha.js"
        script src: "/support/chai.js"
        script src: "/support/sinon.js"

        coffeescript ->
          chai.should()
          mocha.setup("bdd")
          window.Testable = {}

        script src: "/support/chai-jquery.js"
        script src: "/support/sinon-chai.js"
        script src: "/javascripts/vendor/require.min.js"
        script src: "/support/stubs.js"

        script src: "/chat.spec.html.js"
        script src: "/index.spec.js"
        script src: "/coach.spec.js"

        coffeescript ->
          $ ->
            mocha.run( -> window.TESTS_COMPLETE = true)
              .globals [
                'View'
                '$$'
                '$$$'
                'create'
                'ClientUtils'
                '__utils__'
              ]
      body ->
        div "#mocha", ""
        div "#content", ""
  res.end()

port = 1337
app.listen port
console.log 'Express server listening on port %d in %s mode', port, 'development'