require ['/javascripts/ui_components/Chat.html.js', '/javascripts/now/client.js'], (Chat) ->
  $(document).ready ->
    now.ready ->
      $('#start-button').click ->
        $(document.body).html ''
        now.newClient()
        $(document.body).append $$ ->
          @div '.overall', =>
            @h1 'header'
            @subview 'chat', new Chat now