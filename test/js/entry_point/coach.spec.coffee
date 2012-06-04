describe "CoachChat", ->
  before (done) ->
    require ['/js/entry_point/coach.js'], -> done()

  describe "main", ->
    it "appends a new coach interface to the chat window", ->
      $.fn.append = sinon.spy()
      console.log Testable.CoachChat
      Testable.CoachPage.main()
      console.log 'yo'
#      $.fn.append.lastCall.args[0].constructor.should.equal Testable.coach_page.Coach

