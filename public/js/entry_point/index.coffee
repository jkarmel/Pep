Index = {
  setup: (Chat) ->
    Index.Chat = Chat
    $(document).ready ->
      now.ready ->
        Index.main()

  main: ->
    $("#start-button").removeClass('loading').removeClass('disabled')
      .click @loadChat

  loadChat: =>
    $('#content').html ''
    now.newCustomer()
    $('#content').append new Index.Chat now
}

define ['/js/ui/chat.html.js', '/js/now/customer.js'],
        Index.setup

window.Testable?.Index = Index