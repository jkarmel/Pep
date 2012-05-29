define ["/javascripts/vendor/space-pen.js", "/javascripts/vendor/jquery-ui.custom.min.js"], ->
  Chat = class extends View
    @content = ->
      @div ".chat", =>
        @div ".messages", outlet: "messages", ""
        @div '.composer', outlet: 'composer', =>
          @textarea keypress: 'sendMessage'

    initialize: (@now) ->
      now.subscribers.push @render

    render: (client) =>
      @messages.html ""
      currentConvo = client.sessions[client.sessions.length - 1]
      for message in currentConvo.messages
        @addMessage message

    addMessage: (message) ->
      @messages.append $$ ->
        @div ".message", message.body

    sendMessage: (event, element) =>
      if event.which == $.ui.keyCode.ENTER && !event.shiftKey && /\S/.test(element.val())
        @now.addMessage element.val(), => element.val("")

