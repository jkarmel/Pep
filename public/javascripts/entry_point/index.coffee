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
    now.newCustomer()
    $('#content').append new Index.Chat now
}

require ['/javascripts/ui_components/chat.html.js', '/javascripts/now/customer.js'],
        Index.setup

window.Testable?.Index = Index