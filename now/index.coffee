{Customer, Message, Session} = require "../models"
{extend} = require '../utils'

_ = require 'underscore'
_.str = require 'underscore.string'

exports.WRITABLE_FIELDS = WRITABLE_FIELDS = ['email', 'phone']

CustomerMethods =
  newCustomer: (callback) ->
    customer = new Customer
      sessions: [new Session]
    customer.save (error, customer) =>
      callback? @getCustomerGroup customer._id

  # The callback is called w
  getCustomerGroup: (customerId, subscribeCallback) ->
    customerGroup = @getGroup "customer##{customerId}"
    customerGroup._id = customerId

    customerGroup.now.addMessage = (body, callback) ->
      Customer.findOne {_id : customerId}, (error, customer) ->
        messages = customer.sessions[customer.sessions.length - 1].messages
        messages.push new Message body: body
        customer.save (error, doc) ->
          callback?()

    for field in WRITABLE_FIELDS
      do (field) ->
        customerGroup.now["set#{_.str.capitalize field}"] = (entry, callback) ->
          Customer.findOne {_id : customerId}, (error, customer) ->
            customer[field] = entry
            customer.save (error, doc) ->
              callback()

    Customer.findOne {_id: customerId}, (error, customer) ->
      if error
        console.error("Could not find customer #{customerId} to subscribe to!")
        return subscribeCallback?(error)

      customer.subscribe (customer) ->
        customerGroup.now.update customer

      subscribeCallback?()

    customerGroup

exports.extendNow = (now, everyone) ->
  extend now, CustomerMethods

  everyone.now.newCustomer = (callback) ->
    now.newCustomer (group) =>
      group.addUser @user.clientId
      callback?()