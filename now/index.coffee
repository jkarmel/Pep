{Client, Message, Conversation} = require "../models"
{extend} = require '../utils'

clientGroupProperties =
  newClientGroup: (callback) ->
    client = new Client
      conversations: [new Conversation]
    client.save (error, clientdb) =>
      callback? @getClientGroup clientdb._id

  getClientGroup: (clientId) ->
    clientGroup = @getGroup "client##{clientId}"
    clientGroup._id = clientId

    clientGroup.now.addMessage = (body, callback) ->
      Client.findOne {_id : clientId}, (error, client) ->
        messages = client.conversations[client.conversations.length - 1].messages
        messages.push new Message body: body
        client.save (error, doc) ->
          callback?()

    writableFields = 'email phone'.split /\s+/

    for field in writableFields
      do (field) ->
        clientGroup.now["set#{field}"] = (entry, callback) ->
          Client.findOne {_id : clientId}, (error, client) ->
            client[field] = entry
            client.save (error, doc) ->
              callback()

    Client.findOne {_id: clientId}, (error, client) ->
      client.subscribe (clientDoc) ->
        clientGroup.now.update clientDoc

    clientGroup

exports.extendNowjs = (now) ->
  extend now, clientGroupProperties
