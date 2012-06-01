CoachPage = {
  setup: (Coach) ->
    console.log 'setup'
    CoachPage.Coach = Coach
    $(document).ready ->
      now.ready ->
        CoachPage.main()

  main: ->
    console.log 'main'
    $(document.body).append new CoachPage.Coach
}

define ['/javascripts/ui/coach.html.js'], CoachPage.setup

window.Testable?.CoachPage = CoachPage