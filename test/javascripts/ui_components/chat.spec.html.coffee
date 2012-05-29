describe "Chat", ->
  Chat = {}

  before (done) ->
    require [
      '/javascripts/ui_components/chat.html.js'
      '/javascripts/now/customer.js'
    ], (ChatModule) ->
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

    it "it has access to a now instance and reacts to a change in user object", ->
      chat.now.should.exist
      fakeUser =
        sessions: [
          messages: (body: "message number #{num}" for num in [0...10])
        ]
      now.update fakeUser
      chat.messages.find(":contains('message')").length.should.equal 10
      for num in [0...10]
        chat.messages.find(":contains('message number #{num}')").length
          .should.equal 1

      lastMessageText = "last message"
      fakeUser.sessions[0].messages.push body: lastMessageText
      now.update fakeUser
      chat.messages.find(":contains('message')").length.should.equal 11
      chat.messages.find(":contains('#{lastMessageText}')").length
        .should.equal 1

    it 'has a composer that fires now.addMessage on enter', ->
      chat.composer.should.exist

      now.addMessage = sinon.spy()
      chat.composer.children().html('some text')

      chat.composer.children()
        .trigger $.Event('keypress', keyCode: $.ui.keyCode.ENTER, which: 13)
      now.addMessage.should.have.been.calledOnce
      now.addMessage.should.have.been.calledWith('some text')

