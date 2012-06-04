CoachChat = {
  setup: (Coach) ->
    CoachChat.Coach = Coach
    $(document).ready ->
      now.ready ->
        CoachChat.main()

  main: ->
    console.log 'main'
    $(document.body).append new CoachChat.Coach
}

define ['/js/ui/coach.html.js'], CoachChat.setup

window.Testable?.CoachChat = CoachChat