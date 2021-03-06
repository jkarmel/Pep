routes = require '../../routes'

chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'

chai.use sinonChai
should = chai.should()

describe "routes", ->
  describe "index", ->
    it "renders 'index.html.coffee'", ->
      request = {}
      response = { 'render' : sinon.stub() }

      routes.index(request, response)

      response.render.should.have.been.calledWith("index.html.coffee")

  describe "coach", ->
    it "renders 'coach.html.coffee'", ->
      request = {}
      response = { 'render' : sinon.stub() }

      routes.coach(request, response)

      response.render.should.have.been.calledWith("coach.html.coffee")

  describe "style", ->
    it "renders 'style.html.coffee'", ->
      request = {}
      response = { 'render' : sinon.stub() }

      routes.style(request, response)

      response.render.should.have.been.calledWith("style.html.coffee")
