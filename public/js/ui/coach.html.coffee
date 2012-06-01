define ["/js/vendor/space-pen.js", "/js/vendor/jquery-ui.custom.min.js"], ->
  Coach = class extends View
    @content = ->
      @div '.sessions', =>
        @div ".session", =>
          @div ".chat", =>
            @div ".messages", outlet: "messages", ""
            @div '.composer', outlet: 'composer', =>
              @textarea keypress: 'sendMessage'
