models = require '../../models'

chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'

chai.use sinonChai
should = chai.should()

{Session, Message, Customer} = models
{mongoose} = models

describe 'Customer', ->
  customer = null

  beforeEach (done) ->
    Customer.collection.drop()
    customer = new Customer
      name:
        first: 'Jeremy'
        last: 'Karmel'
      email: 'jkarmel@me.com'
      phone: '9178873997'
    customer.save(done)

  it 'finds customers', (done) ->
    Customer.findOne().where( 'name.first', 'Jeremy').run (error, jeremy) ->
      jeremy.name.first.should.equal 'Jeremy'
      jeremy.name.last.should.equal 'Karmel'
      jeremy.email.should.equal 'jkarmel@me.com'
      jeremy.phone.should.equal '9178873997'
      done()

  it 'contains multiple sessions', (done) ->
    sessions = (new Session for i in [0...10])
    for session in sessions
      session.messages.push (new Message body: 'text') for i in [0...10]
      customer.sessions.push session

    customer.save (error) ->
      Customer.findOne {}, (error) ->
        customer.sessions.length.should.be.equal 10
        done()

describe 'Session', ->
  session = null

  beforeEach (done) ->
    Session.collection.drop()
    session = new Session

    for i in [0...10]
      message = new Message body: 'text'
      session.messages.push message

    session.save (error) ->
      done()

  it 'contains many messages', (done) ->
    session.messages.length.should.equal 10
    done()

describe 'Message', ->
  customer = new Customer

  beforeEach (done) ->
    Message.collection.drop()
    message = new Message
      body: 'Main text'
      author:
        id: customer.id
        firstName: 'Jeremy'
    message.save(done)

  it 'has a body', (done) ->
    Message.findOne {}, (error, message) ->
      message.body.should.exist
      done()

  it 'has an author', (done) ->
    Message.findOne {}, (error, message) ->
      message.author.firstName.should.equal 'Jeremy'
      message.author.id.should.eql customer._id
      done()


  it 'sets createdAt to now by default', (done) ->
    Message.findOne {}, (error, message) ->
      oneSecond = 1000
      now = new Date
      timeSinceCreated = now.getTime() - message.createdAt.getTime()
      timeSinceCreated.should.be.within 0, oneSecond
      done()

describe 'setupPubSub', ->

  describe 'with a new model (Test)', ->
    Test = undefined
    test = undefined

    before ->
      Schema = models.mongoose.Schema

      TestSchema = new Schema
        attr: String

      Test = models.mongoose.model 'Test', TestSchema
      models.setupPubSub([Test])

    beforeEach ->
      Test.collection.drop()
      test = new Test

    it 'allows a function to subscribe to changes', (done) ->
      test.should.respondTo 'subscribe'

      spy = sinon.spy()

      test.subscribe spy
      test.save (error) ->
        spy.calledOnce.should.be.true
        done()

    it 'allows multiple functions to subscribe to changes', (done) ->
      test.should.respondTo 'subscribe'

      spies = (sinon.spy() for [0...10])
      test.subscribe spy for spy in spies

      test.save (error) ->
        spy.should.have.been.calledOnce for spy in spies
        done()

  describe 'with a new model that has embedded docs (TestWEmbedded)', ->
    TestWEmbedded = undefined
    testWEmbedded = undefined
    Embedded = undefined
    embedded = undefined

    before ->
      Schema = models.mongoose.Schema

      EmbeddedSchema = new Schema
        attr: String

      TestSchema = new Schema
        attr: String
        embeds: [EmbeddedSchema]

      TestWEmbedded = models.mongoose.model 'TestWEmbedded', TestSchema
      Embedded = models.mongoose.model 'Embedded', EmbeddedSchema

      models.setupPubSub([TestWEmbedded, Embedded])

    beforeEach ->
      TestWEmbedded.collection.drop()
      testWEmbedded = new TestWEmbedded
      embedded = new Embedded
      testWEmbedded.embeds.push embedded

    it 'allows a function to subscribe to changes', (done) ->
      testWEmbedded.should.respondTo 'subscribe'
      embedded.should.respondTo 'subscribe'

      testWEmbedded.subscribe spy = sinon.spy()
      embedded.subscribe embeddedSpy = sinon.spy()

      testWEmbedded.save (error) ->
        spy.should.have.been.calledOnce
        embeddedSpy.should.have.been.calledOnce
        done()

    # NOTE: This fires a bit too often, but it's ok
    it 'fires all the embedded docs subscribers with the embedded doc', (done) ->
      embedded.subscribe embeddedSpy = sinon.spy()
      testWEmbedded.save (error, embeddingDoc) ->
        secondEmbedded = new Embedded attr: "new embedded"

        secondEmbeddedSpy = sinon.spy()
        secondEmbedded.subscribe(secondEmbeddedSpy)
        testWEmbedded.embeds.push secondEmbedded
        testWEmbedded.save (error) ->
          embeddedSpy.should.have.been.calledTwice
          embeddedSpy.getCall(0).args[0].id.should.equal(embedded.id)
          embeddedSpy.getCall(1).args[0].id.should.equal(embedded.id)
          secondEmbeddedSpy.getCall(0).args[0].id.should.equal(secondEmbedded.id)
          done()

  for Model in models.MODELS
    it "is setup on #{Model.modelName}", ->
      modelInstance = new Model
      modelInstance.should.respondTo 'subscribe'
