#Client Function

{Client, Message} = require "../models"

exports.ClientGroup = (now, clientId)->
  clientGroup = now.getGroup "client#clientId"

  clientGroup.now.addMessage = (body, callback)->
    Client.findOne {_id : clientId}, (error, client)->
      messages = client.conversations[client.conversations.length - 1].messages
      messages.push new Message body: body
      client.save (error, doc)->
        callback()


  writableFields = 'email phone'.split /\s+/

  for field in writableFields
    do (field) ->
      clientGroup.now["set#{field}"] = (entry, callback)->
        Client.findOne {_id : clientId}, (error, client)->
          client[field] = entry
          client.save (error, doc)->
            callback()

  return clientGroup