exports.hardcode = {}

exports.hardcode.application = (content) ->
  doctype 5
  html ->
    head ->
      # Favicon
      link rel: "shortcut icon", href: "/favicon.ico"

      # Stylesheets
      # TODO: These need to be compiled into one stylesheet
      link rel: 'stylesheet', href: '/stylesheets/main.css'

      # Javascript Dependencies
      script src: "https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"
      script src: "/nowjs/now.js"
      script type: "text/javascript", src: "http://use.typekit.com/mpr8kpy.js"
      script type: "text/javascript", "try{Typekit.load();}catch(e){}"

      # TODO: TEST, Put this in a requirejs definition
      script type: "text/javascript", src: "/js/vendor/jquery.dropkick.js"
      script type: "text/javascript", src: "/js/vendor/modernizr.custom.min.js"
      script type: "text/javascript", src: "/js/vendor/jquery.placeholder.min.js"
      coffeescript ->
        $(document).ready ->
          unless Modernizr.input.placeholder
            $('input[placeholder], textarea[placeholder]').placeholder()
          $('select').dropkick();

      # Entry point for javascript loading on a page
      # TODO: Minify our javascripts
      if content?.js
        script "data-main": "/js/entry_point/#{content.js}", src: "/js/vendor/require.min.js"

      content?.head?()

    body ->
      div '#content', ->
        content?.body?()