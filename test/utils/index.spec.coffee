chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'

chai.use sinonChai
should = chai.should()

utils = require '../../utils'

describe 'utils', ->
  describe 'extend', ->
    it 'extends the object with the mixin', ->
      object = {}
      mixin = { f : -> }

      utils.extend object, mixin
      object.f.should.equal(mixin.f)

  describe 'include', ->
    it 'extends the class\' prototype with the mixin', ->
      Test = class Test
      mixin = { f : -> }

      utils.extend = sinon.spy()
      utils.include Test, mixin
      utils.extend.should.have.been.calledWith Test.prototype, mixin

