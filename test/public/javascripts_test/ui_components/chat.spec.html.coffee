describe "Chat", ->
  Chat = {}
  now  = {}

  before (done) ->
    require ["/javascripts/ui_components/chat.html.js"], (ChatModule)->
      Chat = ChatModule
      done()

  it "is a subclass of View", ->
    Chat.__super__.constructor.should.equal View

  describe "Chat objects", ->
    chat = {}

    beforeEach (done) ->
      chat = new Chat now
      done()

    it "contains a .messages div", ->
      chat.find(".messages").length.should.equal 1

    it "can display messages", ->
      chat.addMessage {body: "message number #{num}"} for num in [0...10]
      chat.messages.find(":contains('message')").length.should.equal 10
      for num in [0...10]
        chat.messages.find(":contains('message number #{num}')").length
          .should.equal 1

    it "it has access to a now instance and reacts to a change in session", ->
      chat.now.should.exist
      now.sessionChange
         messages: (body: "message number #{num}" for num in [0...10])
      chat.messages.find(":contains('message')").length.should.equal 10
      for num in [0...10]
        chat.messages.find(":contains('message number #{num}')").length
          .should.equal 1
