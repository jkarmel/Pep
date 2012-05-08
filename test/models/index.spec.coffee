models = require '../../models'

chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'

chai.use sinonChai
should = chai.should()

describe 'Client', ->
  {Client} = models
  currentClient = null

  beforeEach (done)->
    Client.collection.drop()
    client = new Client
      name:
        first: 'Jeremy'
        last: 'Karmel'
      email: 'jkarmel@me.com'
      phone: '9178873997'
    client.save(done)

  it 'finds clients', (done)->
    Client.findOne().where( 'name.first', 'Jeremy').run (error, jeremy)->
      jeremy.name.first.should.equal 'Jeremy'
      jeremy.name.last.should.equal 'Karmel'
      jeremy.email.should.equal 'jkarmel@me.com'
      jeremy.phone.should.equal '9178873997'
      done()

describe 'Conversation', ->
  {Conversation, Message} = models
  conversation = null

  beforeEach (done)->
    Conversation.collection.drop()
    conversation = new Conversation

    for i in [0...10]
      message = new Message body: 'text'
      conversation.messages.push message

    conversation.save (error)->
      done()

  it 'contains many messages', (done)->
    conversation.messages.length.should.equal 10
    done()


describe 'Message', ->
  {Message} = models

  beforeEach (done)->
    Message.collection.drop()
    message = new Message
      body: 'Main text'
    message.save(done)

  it 'sets createdAt to now by default', (done)->
    Message.findOne {}, (error, message)->
      oneSecond = 1000
      now = new Date
      timeSinceCreated = now.getTime() - message.createdAt.getTime()
      timeSinceCreated.should.be.within 0, oneSecond
      done()

