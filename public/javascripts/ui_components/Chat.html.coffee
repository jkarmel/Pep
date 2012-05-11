define ["/javascripts/vendor/space-pen.js"], ->
  Chat = class extends View
    @content = ->
      @div ".chat", =>
        @div ".messages", outlet: "messages", ""

    initialize: (@now) ->
      @setupNow()

    setupNow: ->
      @now.sessionChange = (session) => @render session

    render: (session) ->
      @messages.val ""
      for message in session.messages
        @addMessage message

    addMessage: (message) ->
      @messages.append $$ ->
        @div ".message", message.body

