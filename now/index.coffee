{Client, Message, Session} = require "../models"
{extend} = require '../utils'

_ = require 'underscore'
_.str = require 'underscore.string'

exports.WRITABLE_FIELDS = WRITABLE_FIELDS = [ 'email', 'phone' ]

clientGroupProperties =
  newClientGroup: (callback) ->
    client = new Client
      sessions: [new Session]
    client.save (error, clientdb) =>
      callback? @getClientGroup clientdb._id

  getClientGroup: (clientId) ->
    clientGroup = @getGroup "client##{clientId}"
    clientGroup._id = clientId

    clientGroup.now.addMessage = (body, callback) ->
      Client.findOne {_id : clientId}, (error, client) ->
        messages = client.sessions[client.sessions.length - 1].messages
        messages.push new Message body: body
        client.save (error, doc) ->
          callback?()

    for field in WRITABLE_FIELDS
      do (field) ->
        clientGroup.now["set#{_.str.capitalize field}"] = (entry, callback) ->
          Client.findOne {_id : clientId}, (error, client) ->
            client[field] = entry
            client.save (error, doc) ->
              callback()

    Client.findOne {_id: clientId}, (error, client) ->
      client.subscribe (clientDoc) ->
        clientGroup.now.update clientDoc

    clientGroup

exports.extendNow = (now, everyone) ->
  extend now, clientGroupProperties

  everyone.now.newClient = (callback) ->
    now.newClientGroup (group) =>
      group.addUser @user.clientId
      callback?()