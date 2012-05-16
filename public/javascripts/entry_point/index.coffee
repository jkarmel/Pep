require ['/javascripts/ui_components/Chat.html.js', '/javascripts/now/client.js'], (Chat) ->

  $document = $(document)

  $(document).ready ->
    now.ready ->
      $('.start_button').click ->
        $(document.body).html ''
        $document.append new Chat now