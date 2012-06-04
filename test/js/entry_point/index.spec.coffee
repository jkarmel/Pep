describe "Index", ->
  before (done) ->
    require ['/js/entry_point/index.js'], -> done()

  describe "require", ->
    it "calls main once all modules are loaded", ->
#      require.should.have.been.calledWith sinon.match.any, Testable.Index.main

  describe "main", ->
    it "binds click to start button", ->
      $.fn.click = sinon.spy()
      Testable.Index.main()
      $.fn.click.should.have.been.calledWith Testable.Index.loadSession
      Test.withSelector '#start-button', $.fn.click.lastCall

    it "removes loading and disabled", ->
      sinon.spy $.fn, 'removeClass'
      Testable.Index.main()
      $.fn.removeClass.calledWith('loading').should.be.true
      $.fn.removeClass.calledWith('disabled').should.be.true
      Test.withSelector '#start-button', $.fn.removeClass.lastCall
      $.fn.removeClass.restore()

  describe "loadSession", ->
    before ->
      Testable.Index.Session = class
        initialize: (@now) ->

    beforeEach ->
      $('#content').append "<div id='old'></div>"

    it "empties the document body", ->
      $('#old').should.exist
      Testable.Index.loadSession()
      $('#old').should.not.exist

    it "creates a new customer", ->
      now.newCustomer = sinon.spy()
      Testable.Index.loadSession()
      now.newCustomer.should.have.been.called

    it "adds a Session window to content", ->
      $.fn.append = sinon.spy()
      Testable.Index.loadSession()
      session = $.fn.append.lastCall.args[0]

      session.constructor.should.equal Testable.Index.Session
      Test.withSelector '#content', $.fn.append.lastCall
      # TODO: Test now is in there?