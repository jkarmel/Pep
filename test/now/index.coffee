routes = require '../../routes'

chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'

chai.use sinonChai
should = chai.should()

_ = require 'underscore'

{Client, Conversation, Message} = require '../../models'
{ClientGroup, newClientGroup, extendNowjs} = require '../../now'

describe 'extendNowjs', ->
  nowMock = {getGroup: -> {now : {}} }
  extendNowjs nowMock

  describe 'newClientGroup', ->

    it 'can create a new client group',  (done) ->
      nowMock.newClientGroup (group) ->
        feelWellAdress = 'jeremy@feelwelllabs.com'
        group.now.setemail feelWellAdress, ->
          Client.findOne {_id: group._id}, (error, client) ->
            client.email.should.equal feelWellAdress
            done()

  describe 'getClientGroup', ->
    clientGroup = null
    clientId = null

    beforeEach (done) ->
      Client.collection.drop()
      Conversation.collection.drop()
      client = new Client
          name: {first: 'Jeremy', last: 'Karmel'}
          email: 'jkarmel@me.com'
          phone: '9178873997'
      for i in [0...10]
        conversation = new Conversation
        for j in [0...10]
          conversation.messages.push new Message body: 'old text'
        client.conversations.push conversation
      client.save (error, clientdb) ->
        clientId = clientdb._id
        clientGroup = nowMock.getClientGroup clientId
        done()

    it 'can add messages to the most recent conversation', (done) ->
      clientGroup.now.should.respondTo 'addMessage'
      newestMessageText = 'lastest text'
      clientGroup.now.addMessage newestMessageText, ->
        Client.findOne {'email': 'jkarmel@me.com'}, (error, client) ->
          lastMessage = _.last (_.last client.conversations).messages
          lastMessage.body.should.equal newestMessageText
          done()

    writableFields = 'email phone'.split /\s+/

    for field in writableFields
      do (field) ->
        it "can write to #{field}", (done) ->
          methodName = "set#{field}"
          clientGroup.now.should.respondTo methodName
          fakeEntry = "fake #{field}"
          clientGroup.now[methodName] fakeEntry, ->
            Client.findOne {}, (error, client) ->
              client[field].should.equal fakeEntry
              done()
