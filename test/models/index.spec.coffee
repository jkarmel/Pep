models = require '../../models'

chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'

chai.use sinonChai
should = chai.should()

{Conversation, Message, Client} = models

describe 'Client', ->
  client = null

  beforeEach (done) ->
    Client.collection.drop()
    client = new Client
      name:
        first: 'Jeremy'
        last: 'Karmel'
      email: 'jkarmel@me.com'
      phone: '9178873997'
    client.save(done)

  it 'finds clients', (done) ->
    Client.findOne().where( 'name.first', 'Jeremy').run (error, jeremy) ->
      jeremy.name.first.should.equal 'Jeremy'
      jeremy.name.last.should.equal 'Karmel'
      jeremy.email.should.equal 'jkarmel@me.com'
      jeremy.phone.should.equal '9178873997'
      done()

  it 'contains multiple conversations', (done) ->
    convos = (new Conversation for i in [0...10])
    for convo in convos
      convo.messages.push (new Message body: 'text') for i in [0...10]
      client.conversations.push convo

    client.save (error) ->
      Client.findOne {}, (error) ->
        client.conversations.length.should.be.equal 10

        done()

describe 'Conversation', ->
  conversation = null

  beforeEach (done) ->
    Conversation.collection.drop()
    conversation = new Conversation

    for i in [0...10]
      message = new Message body: 'text'
      conversation.messages.push message

    conversation.save (error) ->
      done()

  it 'contains many messages', (done) ->
    conversation.messages.length.should.equal 10
    done()


describe 'Message', ->

  beforeEach (done) ->
    Message.collection.drop()
    message = new Message
      body: 'Main text'
    message.save(done)

  it 'sets createdAt to now by default', (done) ->
    Message.findOne {}, (error, message) ->
      oneSecond = 1000
      now = new Date
      timeSinceCreated = now.getTime() - message.createdAt.getTime()
      timeSinceCreated.should.be.within 0, oneSecond
      done()

describe 'setupPubSub', ->
  it 'allows Conversation objects to respond to subscribe', (done) ->
    models.setupPubSub()
    Conversation.collection.drop()
    conversation = new Conversation
    for i in [0...10]
      message = new Message body: 'text'
      conversation.messages.push message

    conversation.should.respondTo 'subscribe'

    spy = sinon.spy()

    conversation.subscribe spy
    conversation.save (error) ->
      spy.calledOnce.should.be.true
      done()

  it 'allows you to track changes to embedded documents', (done) ->
    Client.collection.drop()
    client = new Client
        name:
          first: 'Jeremy'
          last: 'Karmel'
        email: 'jkarmel@me.com'
        phone: '9178873997'

    conversation = new Conversation
    client.conversations.push conversation

    client.subscribe outerSpy = sinon.spy()
    conversation.subscribe embeddedSpy = sinon.spy()
    client.save ->
      outerSpy.should.have.been.calledOnce
      embeddedSpy.should.have.been.calledOnce
      Client.findOne {}, (error, doc) ->
        doc.conversations[0].messages.push new Message body: 'some text'
        doc.save ->
          embeddedSpy.should.have.been.calledTwice
          done()
