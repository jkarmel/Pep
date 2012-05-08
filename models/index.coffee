mongoose = require 'mongoose'
mongoose.connect process.env.MONGOHQ_URL, (error) ->
  if error
    console.error "Could not connect to MongoDB"
    throw error

Schema = mongoose.Schema

ClientSchema = new Schema
  clientId: String
  name:
    first: String
    last: String
    middle: String
  email: String
  phone: String

ConversationSchema = new Schema
  messages: [MessageSchema]

MessageSchema = new Schema
  body: String
  createdAt: {type: Date, default: Date.now}

exports.Client = Client = mongoose.model 'Client', ClientSchema
exports.Conversation = Conversation = mongoose.model 'Conversation', ConversationSchema
exports.Message = Message = mongoose.model 'Message', MessageSchema

