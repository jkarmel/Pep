describe "Chat", ->
  Chat = {}

  before (done) ->
    require [
      '/javascripts/ui/chat.html.js'
      '/javascripts/now/customer.js'
    ], (ChatModule) ->
      Chat = ChatModule
      done()

  it "is a subclass of View", ->
    Chat.__super__.constructor.should.equal View

  describe "Chat objects", ->
    chat = {}

    describe 'content', ->
      before ->
        chat = new Chat now

      it "contains .messages", ->
        chat.find(".messages").length.should.equal 1

      it "contains .composer", ->
        chat.find(".composer").length.should.equal 1

    describe 'initialize', ->
      it "subscribes render", ->
        now.subscribers.push = sinon.spy()
        chat = new Chat now
        now.subscribers.push.should.have.been.calledWith chat.render

    describe 'methods', ->
      beforeEach ->
        chat = new Chat now

      describe 'render', ->
        fakeCoach = {id: 2, name: 'Abhik'}

        beforeEach ->
          fakeCustomerData = {id: 1, name: 'Jeremy'}
          fakeCustomer =
            id: 1
            name: 'Jeremy'
            sessions: [
              messages: [
                {body: 'message number 0', author: fakeCoach}
                {body: 'message number 1', author: fakeCoach}
                {body: 'message number 2', author: fakeCoach}
                {body: 'message number 3', author: fakeCustomerData}
                {body: 'message number 4', author: fakeCustomerData}
              ]
            ]
          chat.render fakeCustomer

        it "renders each message", ->
          chat.messages.find(".body:contains('message')").length.should.equal 5
          for num in [0...5]
            chat.messages.find(".body:contains('message number #{num}')").length
              .should.equal 1

        it "doesn't render the author's name above a message from the current user", ->
          chat.messages.find(".body:contains('message number 3')").parent()
            .find('.author').length.should.equal 0
          chat.messages.find(".body:contains('message number 4')").parent()
            .find('.author').length.should.equal 0

        it "doesn't render the author's above a message if it's not the first message in a group", ->
          chat.messages.find(".body:contains('message number 1')").parent()
          .find('.author').length.should.equal 0
          chat.messages.find(".body:contains('message number 2')").parent()
          .find('.author').length.should.equal 0

        it "renders the author's name above the first message in a group", ->
          chat.messages.find(".body:contains('message number 0')").parent()
          .find(".author:contains('#{fakeCoach.name}')").length.should.equal 1

      describe 'addMessage', ->
        it "displays messages", ->
          chat.addMessage {body: "message number #{num}"} for num in [0...10]
          chat.messages.find(".body:contains('message')").length.should.equal 10
          for num in [0...10]
            chat.messages.find(".body:contains('message number #{num}')").length
            .should.equal 1

      describe 'composer', ->
        beforeEach ->
          now.addMessage = sinon.spy()

        it 'fires now.addMessage on enter', ->
          chat.composer.should.exist

          chat.composer.children().html('some text')

          chat.composer.children()
            .trigger $.Event('keypress', keyCode: $.ui.keyCode.ENTER, which: 13)
          now.addMessage.should.have.been.calledOnce
          now.addMessage.should.have.been.calledWith('some text')

        it 'doesn\'t send a message if the shift key is pressed', ->
          chat.composer.children().html('some text')

          chat.composer.children()
          .trigger $.Event('keypress', keyCode: $.ui.keyCode.ENTER, shiftKey: true, which: 13)
          now.addMessage.should.not.have.been.called


        it 'doesn\'t send a message if the message is only spaces', ->
          chat.composer.children().html('               \t\t\n')

          chat.composer.children()
          .trigger $.Event('keypress', keyCode: $.ui.keyCode.ENTER, which: 13)
          now.addMessage.should.not.have.been.called

