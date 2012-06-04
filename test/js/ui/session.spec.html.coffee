describe "Session", ->
  Session = {}

  before (done) ->
    require [
      '/js/ui/session.html.js'
      '/js/now/customer.js'
    ], (SessionModule) ->
      Session = SessionModule
      done()

  it "is a subclass of View", ->
    Session.__super__.constructor.should.equal View

  describe "Session objects", ->
    session = {}

    describe 'content', ->
      before ->
        session = new Session now

      it "contains .messages", ->
        session.find(".messages").length.should.equal 1

      it "contains .composer", ->
        session.find(".composer").length.should.equal 1

    describe 'initialize', ->
      it "subscribes render", ->
        now.subscribers.push = sinon.spy()
        session = new Session now
        now.subscribers.push.should.have.been.calledWith session.render

    describe 'methods', ->
      beforeEach ->
        session = new Session now

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
          session.render fakeCustomer

        it "renders each message", ->
          session.messages.find(".body:contains('message')").length.should.equal 5
          for num in [0...5]
            session.messages.find(".body:contains('message number #{num}')").length
              .should.equal 1

        it "doesn't render the author's name above a message from the current user", ->
          session.messages.find(".body:contains('message number 3')").parent()
            .find('.author').length.should.equal 0
          session.messages.find(".body:contains('message number 4')").parent()
            .find('.author').length.should.equal 0

        it "doesn't render the author's above a message if it's not the first message in a group", ->
          session.messages.find(".body:contains('message number 1')").parent()
          .find('.author').length.should.equal 0
          session.messages.find(".body:contains('message number 2')").parent()
          .find('.author').length.should.equal 0

        it "renders the author's name above the first message in a group", ->
          session.messages.find(".body:contains('message number 0')").parent()
          .find(".author:contains('#{fakeCoach.name}')").length.should.equal 1

      describe 'addMessage', ->
        it "displays messages", ->
          session.addMessage {body: "message number #{num}"} for num in [0...10]
          session.messages.find(".body:contains('message')").length.should.equal 10
          for num in [0...10]
            session.messages.find(".body:contains('message number #{num}')").length
            .should.equal 1

      describe 'composer', ->
        beforeEach ->
          now.addCustomerMessage = sinon.spy()

        it 'fires now.addCustomerMessage on enter', ->
          session.composer.should.exist

          session.composer.children().html('some text')

          session.composer.children()
            .trigger $.Event('keypress', keyCode: $.ui.keyCode.ENTER, which: 13)
          now.addCustomerMessage.should.have.been.calledOnce
          now.addCustomerMessage.should.have.been.calledWith('some text')

        it 'doesn\'t send a message if the shift key is pressed', ->
          session.composer.children().html('some text')

          session.composer.children()
          .trigger $.Event('keypress', keyCode: $.ui.keyCode.ENTER, shiftKey: true, which: 13)
          now.addCustomerMessage.should.not.have.been.called


        it 'doesn\'t send a message if the message is only spaces', ->
          session.composer.children().html('               \t\t\n')

          session.composer.children()
          .trigger $.Event('keypress', keyCode: $.ui.keyCode.ENTER, which: 13)
          now.addCustomerMessage.should.not.have.been.called

