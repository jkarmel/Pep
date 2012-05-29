chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'

chai.use sinonChai
should = chai.should()

_ = require 'underscore'
_.str = require 'underscore.string'

{Customer, Session, Message} = require '../../models'
{WRITABLE_FIELDS, extendNow} = require '../../now'

describe 'extendNow', ->
  spy = sinon.spy()
  now = {getGroup: -> {now : {update: spy}}}
  everyone = {now: {}}
  extendNow now, everyone

  describe 'newCustomerGroup', ->
    it 'can create a new customer group',  (done) ->
      now.newCustomerGroup (group) ->
        feelWellAdress = 'jeremy@feelwelllabs.com'
        group.now.setEmail feelWellAdress, ->
          Customer.findOne {_id: group._id}, (error, customer) ->
            customer.email.should.equal feelWellAdress
            spy.should.have.been.calledOnce
            done()

  describe 'getCustomerGroup', ->
    customerGroup = null
    customerId = null

    beforeEach (done) ->
      Customer.collection.drop()
      Session.collection.drop()
      customer = new Customer
          name: {first: 'Jeremy', last: 'Karmel'}
          email: 'jkarmel@me.com'
          phone: '9178873997'
      for i in [0...10]
        session = new Session
        for j in [0...10]
          session.messages.push new Message body: 'old text'
        customer.sessions.push session
      customer.save (error, customerdb) ->
        customerId = customerdb._id
        customerGroup = now.getCustomerGroup customerId
        done()

    it 'can add messages to the most recent session', (done) ->
      customerGroup.now.should.respondTo 'addMessage'
      newestMessageText = 'lastest text'
      customerGroup.now.addMessage newestMessageText, ->
        Customer.findOne {'email': 'jkarmel@me.com'}, (error, customer) ->
          lastMessage = _.last (_.last customer.sessions).messages
          lastMessage.body.should.equal newestMessageText
          done()

    for field in WRITABLE_FIELDS
      do (field) ->
        methodName = "set#{_.str.capitalize field}"
        it "can write to #{field.toLowerCase()} through now method #{methodName}", (done) ->
          customerGroup.now.should.respondTo methodName
          fakeEntry = "fake #{field}"
          customerGroup.now[methodName] fakeEntry, ->
            Customer.findOne {}, (error, customer) ->
              customer[field].should.equal fakeEntry
              done()
