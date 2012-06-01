define ["/javascripts/vendor/space-pen.js", "/javascripts/vendor/jquery-ui.custom.min.js"], ->
  Coach = class extends View
    @content = ->
      @div '.sessions', =>
        @div ".session", =>
          @div ".chat", =>
            @div ".messages", outlet: "messages", ""
            @div '.composer', outlet: 'composer', =>
              @textarea keypress: 'sendMessage'
