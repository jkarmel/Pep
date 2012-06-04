express = require 'express'
lessMiddleware = require 'less-middleware'

app = module.exports = express.createServer()

app.configure ->
  # View Configuration
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'coffee'
  app.set 'view options',
    layout: false

  app.register '.coffee', require('coffeekup').adapters.express

  app.use express.bodyParser()
  app.use express.methodOverride()

  # Compile Less
  app.use express.compiler
    src: __dirname + '/public'
    enable: [ 'less' ]

  app.use lessMiddleware
    src: __dirname + '/public',
    compress: true

  # Compile public Coffeescript
  app.use express.compiler
    src: __dirname + '/public'
    enable: [ 'coffeescript' ]

  app.use express.cookieParser()

  # TODO: Set this to a secret value to encrypt session cookies
  app.use express.session secret: process.env.SESSION_SECRET || 'secret123'

  app.helpers require './helpers/layouts'

  app.use app.router

  # Serve public files statically
  app.use express.static(__dirname + '/public')

app.configure 'development', ->
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true

app.configure 'production', ->
  app.use express.errorHandler()

routes = require './routes'

app.get '/', routes.index
app.get '/coach/sessions', routes.coach
app.get '/style', routes.style

port = process.env.PORT || 3000
app.listen port
console.log 'Express server listening on port %d in %s mode', app.address().port, app.settings.env

# ------------------------------------------------------------------------------
# NowJS
# ------------------------------------------------------------------------------
now = require("now")

# If using HEROKU to serve, downgrade transport to xhr and json, since heroku
# does not support websockets.
nowSettings = {}
if process.env.HEROKU
  nowSettings =
    socketio:
      transports: [ 'xhr-polling', 'jsonp-polling' ]

everyone = now.initialize app, nowSettings

require('./now').extendNow now, everyone
