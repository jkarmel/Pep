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
  now = {getGroup: -> {now : {update: sinon.spy()}}}
  everyone = {now: {}}
  extendNow now, everyone

  describe 'newCustomer', ->
    it 'creates a new customer', (done) ->
      Customer.count (error, initialCount) ->
        now.newCustomer ->
          Customer.count (error, endCount) ->
            (endCount - 1).should.equal initialCount
            done()

    it 'creates a new customer group and returns it in the callback',  (done) ->
      Customer.collection.drop()
      sinon.stub(now, 'getCustomerGroup').returns 1

      now.newCustomer (customerGroup) ->
        Customer.findOne {}, (error, customer) ->
          customerGroup.should.equal 1
          now.getCustomerGroup.should.have.been.calledWith customer._id
          now.getCustomerGroup.restore()
          done()

  describe 'getCustomerGroup', ->
    customerGroup = undefined
    customerId = undefined
    customer = undefined

    beforeEach (done) ->
      Customer.collection.drop()
      Session.collection.drop()
      customer = new Customer
        name: {first: 'Jeremy', last: 'Karmel'}
        email: 'jeremy@example.com'
        phone: '911'
      for i in [0...10]
        session = new Session
        for j in [0...10]
          session.messages.push new Message body: 'old text'
        customer.sessions.push session
      customer.save (error, customer) ->
        customerId = customer._id
        customerGroup = now.getCustomerGroup customerId
        done()

    it "creates a group from the customer id", ->
      sinon.spy now, 'getGroup'
      group = now.getCustomerGroup customerId
      now.getGroup.getCall(0).args[0].should.match new RegExp "#{customerId}"
      group._id.should.equal customerId
      now.getGroup.restore()

    it "subscribes the group to updates from the customer", (done) ->
      group = now.getCustomerGroup customerId, (error) ->
        customer.phone = '311'
        customer.save (error, customer) ->
          group.now.update.should.have.been.called
          group.now.update.getCall(0).args[0]._id.should.equal customerId
          done()

    it "returns an error if subscription to the customer fails", (done) ->
      group = now.getCustomerGroup '12', (error) ->
        error.should.exist
        done()

    describe "now", ->
      describe "addMessage", ->
        it 'adds messages to the most recent session', (done) ->
          customerGroup.now.should.respondTo 'addMessage'
          newestMessageText = 'lastest text'
          customerGroup.now.addMessage newestMessageText, ->
            Customer.findOne {'email': 'jeremy@example.com'}, (error, customer) ->
              lastMessage = _.last (_.last customer.sessions).messages
              lastMessage.body.should.equal newestMessageText
              lastMessage.author.id.should.eql customer._id
              lastMessage.author.firstName.should.equal customer.name.first
              done()

      for field in WRITABLE_FIELDS
        do (field) ->
          methodName = "set#{_.str.capitalize field}"
          describe "#{methodName}", ->
            it "can write to #{field.toLowerCase()}", (done) ->
              customerGroup.now.should.respondTo methodName
              fakeEntry = "fake #{field}"
              customerGroup.now[methodName] fakeEntry, ->
                Customer.findOne {}, (error, customer) ->
                  customer[field].should.equal fakeEntry
                  done()
