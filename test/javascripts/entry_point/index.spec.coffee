describe "Index", ->
  before (done) ->
    require ['/javascripts/entry_point/index.js'], done

  describe "require", ->
    it "calls main once all modules are loaded", ->
#      require.should.have.been.calledWith sinon.match.any, Testable.Index.main

  describe "main", ->
    it "binds click to start button", ->
      $.fn.click = sinon.spy()
      Testable.Index.main()
      $.fn.click.should.have.been.calledWith Testable.Index.loadChat
      Test.withSelector '#start-button', $.fn.click.lastCall

  describe "loadChat", ->
    before ->
      Testable.Index.Chat = class
        initialize: (@now) ->

    beforeEach ->
      $('#content').append "<div id='old'></div>"

    it "empties the document body", ->
      $('#old').should.exist
      Testable.Index.loadChat()
      $('#old').should.not.exist

    it "creates a new client", ->
      now.newClient = sinon.spy()
      Testable.Index.loadChat()
      now.newClient.should.have.been.called

    it "adds a Chat window to content", ->
      $.fn.append = sinon.spy()
      Testable.Index.loadChat()
      console.log $.fn.append.lastCall.args[0].constructor
      chat = $.fn.append.lastCall.args[0]

      chat.constructor.should.equal Testable.Index.Chat
      Test.withSelector '#content', $.fn.append.lastCall
      # TODO: Test now is in there?