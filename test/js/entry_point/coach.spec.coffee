describe "CoachPage", ->
  before (done) ->
    require ['/js/entry_point/coach.js'], -> done()

  describe "main", ->
    it "appends a new coach interface to the chat window", ->
      $.fn.append = sinon.spy()
      console.log Testable
      Testable.CoachPage.main()
#      console.log $.fn.append.lastCall
#      $.fn.append.lastCall.args[0].constructor.should.equal Testable.coach_page.Coach

