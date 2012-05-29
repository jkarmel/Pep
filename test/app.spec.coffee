chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
express = require 'express'

chai.use sinonChai
should = chai.should()

process.env.PORT = 8080
app = require '../app.coffee'

describe 'app', ->
  describe 'configure', ->
    it 'uses coffee as the view engine', ->
      app.settings['view engine'].should.equal 'coffee'

    it 'pull views from the /views', ->
      app.settings.views.should.match /\/views$/

    it 'doesn\'t use layouts', ->
      app.settings['view options'].layout.should.be.false

    # NOTE: Can't test the existence of middleware stack because the functions are created dynamically

    it 'listens on the port specified by the environment', ->
      app.address().port.should.equal parseInt process.env.PORT

    it 'defaults to the development environment', ->
      app.settings.env.should.equal 'development'

    # TODO: Test that we can spin up the production environment?

  # TODO: Test now

