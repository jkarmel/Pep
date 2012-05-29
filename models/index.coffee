exports.mongoose = mongoose = require 'mongoose'
mongoose.connect process.env.MONGOHQ_URL, (error) ->
  if error
    console.error "Could not connect to MongoDB"
    throw error

Schema = mongoose.Schema

SessionSchema = new Schema
    messages: [MessageSchema]

MessageSchema = new Schema
    body: String
    createdAt: {type: Date, default: Date.now}

CustomerSchema = new Schema
  name:
    first: String
    last: String
    middle: String
  email: String
  phone: String
  sessions: [SessionSchema]

exports.Customer = Customer = mongoose.model 'Customer', CustomerSchema
exports.Session = Session = mongoose.model 'Session', SessionSchema
exports.Message = Message = mongoose.model 'Message', MessageSchema

# Allows listening to changes on specified models.
# TODO: This might not scale to multiple boxes
pubsToSubs = {}
exports.setupPubSub = setupPubSub = (models) ->
  # Publish on save
  for model in models
    do (model) ->
      model.schema.post 'save', (next) ->
        if pubsToSubs[model.modelName]?[@_id]
          for func in pubsToSubs[model.modelName][@_id]
            func(@)

      model.prototype.subscribe = (func) ->
        pubsToSubs[model.modelName] ?= {}
        pubsToSubs[model.modelName][@_id] ?= []

        pubsToSubs[model.modelName][@_id].push func

exports.MODELS = MODELS = [ Session, Message, Customer ]

setupPubSub(MODELS)

exports.clearSubs = -> pubsToSubs = {}