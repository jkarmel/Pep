chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'

chai.use sinonChai
should = chai.should()

_ = require 'underscore'
_.str = require 'underscore.string'

{Client, Session, Message} = require '../../models'
{WRITABLE_FIELDS, extendNow} = require '../../now'

describe 'extendNow', ->
  spy = sinon.spy()
  now = {getGroup: -> {now : {update: spy}}}
  everyone = {now: {}}
  extendNow now, everyone

  describe 'newClientGroup', ->
    it 'can create a new client group',  (done) ->
      now.newClientGroup (group) ->
        feelWellAdress = 'jeremy@feelwelllabs.com'
        group.now.setEmail feelWellAdress, ->
          Client.findOne {_id: group._id}, (error, client) ->
            client.email.should.equal feelWellAdress
            spy.should.have.been.calledOnce
            done()

  describe 'getClientGroup', ->
    clientGroup = null
    clientId = null

    beforeEach (done) ->
      Client.collection.drop()
      Session.collection.drop()
      client = new Client
          name: {first: 'Jeremy', last: 'Karmel'}
          email: 'jkarmel@me.com'
          phone: '9178873997'
      for i in [0...10]
        session = new Session
        for j in [0...10]
          session.messages.push new Message body: 'old text'
        client.sessions.push session
      client.save (error, clientdb) ->
        clientId = clientdb._id
        clientGroup = now.getClientGroup clientId
        done()

    it 'can add messages to the most recent session', (done) ->
      clientGroup.now.should.respondTo 'addMessage'
      newestMessageText = 'lastest text'
      clientGroup.now.addMessage newestMessageText, ->
        Client.findOne {'email': 'jkarmel@me.com'}, (error, client) ->
          lastMessage = _.last (_.last client.sessions).messages
          lastMessage.body.should.equal newestMessageText
          done()

    for field in WRITABLE_FIELDS
      do (field) ->
        methodName = "set#{_.str.capitalize field}"
        it "can write to #{field.toLowerCase()} through now method #{methodName}", (done) ->
          clientGroup.now.should.respondTo methodName
          fakeEntry = "fake #{field}"
          clientGroup.now[methodName] fakeEntry, ->
            Client.findOne {}, (error, client) ->
              client[field].should.equal fakeEntry
              done()