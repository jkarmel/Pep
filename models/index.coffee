mongoose = require 'mongoose'
mongoose.connect process.env.MONGOHQ_URL, (error) ->
  if error
    console.error "Could not connect to MongoDB"
    throw error

Schema = mongoose.Schema

ConversationSchema = new Schema
    messages: [MessageSchema]

MessageSchema = new Schema
    body: String
    createdAt: {type: Date, default: Date.now}

ClientSchema = new Schema
  clientId: String
  name:
    first: String
    last: String
    middle: String
  email: String
  phone: String
  conversations: [ConversationSchema]


exports.Client = Client = mongoose.model 'Client', ClientSchema
exports.Conversation = Conversation = mongoose.model 'Conversation', ConversationSchema
exports.Message = Message = mongoose.model 'Message', MessageSchema

SchemaModelPairs = [
  [ConversationSchema, Conversation]
  [MessageSchema, Message]
  [ClientSchema, Client]
]

publishers = {}
exports.setupPubSub = ->

  #Publish on save
  for [schema, model] in SchemaModelPairs
    do (schema, model) ->

      # setup publishing
      schema.post 'save', (next) ->
        if publishers[model.modelName]?[@_id]
          for func in publishers[model.modelName][@_id]
            func(@)

      model.prototype.subscribe = (func) ->
        if publishers[model.modelName] == undefined
          publishers[model.modelName] = {}
        if  publishers[model.modelName][@_id] == undefined
          publishers[model.modelName][@_id] = []

        publishers[model.modelName][@_id].push func

exports.clearSubs = -> publishers = {}