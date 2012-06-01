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

define ['/javascripts/ui/chat.html.js', '/javascripts/now/customer.js'],
        Index.setup

window.Testable?.Index = Index