define ["/javascripts/vendor/space-pen.js", "/javascripts/vendor/jquery-ui.custom.min.js"], ->
  Chat = class extends View
    @content = ->
      @div ".session", =>
        @div ".chat", =>
          @div ".messages", outlet: "messages", ""
          @div '.composer', outlet: 'composer', =>
            @textarea keypress: 'sendMessage'

    initialize: (@now) ->
      now.subscribers.push @render

    render: (customer) =>
      @messages.html ""
      currentConvo = customer.sessions[customer.sessions.length - 1]

      lastAuthor = undefined
      for message in currentConvo.messages
        if lastAuthor == message.author || message.author?.id == customer.id
          @addMessage message
        else
          @addMessage message, true
        lastAuthor = message.author

    addMessage: (message, showAuthor) ->
      @messages.append $$ ->
        @div ".message", =>
          if showAuthor
            @p '.author', message.author.name
          @p ".body", message.body

    sendMessage: (event, element) =>
      if event.which == $.ui.keyCode.ENTER && !event.shiftKey && /\S/.test(element.val())
        @now.addMessage element.val(), => element.val("")

