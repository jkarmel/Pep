Index = {
  setup: (Chat) ->
    Index.Chat = Chat
    $(document).ready ->
      now.ready ->
        Index.main()

  main: ->
    $('#start-button').click @loadChat

  loadChat: =>
    $('#content').html ''
    now.newClient()
    $('#content').append new Index.Chat now
}

require ['/javascripts/ui_components/chat.html.js', '/javascripts/now/client.js'],
        Index.setup

window.Testable?.Index = Index