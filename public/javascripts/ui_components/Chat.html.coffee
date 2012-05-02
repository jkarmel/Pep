define ["/javascripts/vendor/space-pen.js"], ->
  Chat = class extends View
    @content = ->
      @div ".chat", =>
        @div ".messages", outlet: "messages", ""

    addMessage: (message) ->
      @messages.append $$ ->
        @div ".message", message.body

  Chat