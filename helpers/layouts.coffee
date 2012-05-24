exports.hardcode = {}

exports.hardcode.application = (content) ->
  doctype 5
  html ->
    head ->
      # Favicon
      link rel: "shortcut icon", href: "/favicon.ico"

      # Stylesheets
      link rel: 'stylesheet', href: '/stylesheets/reset.css'
      link rel: 'stylesheet', href: '/stylesheets/main.css'

      # Javascript Dependencies
      script src: "https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"
      script src: "/nowjs/now.js"
      script type: "text/javascript", src: "http://use.typekit.com/mpr8kpy.js"
      script type: "text/javascript", "try{Typekit.load();}catch(e){}"

      # Entry point for javascript loading on a page
      if content?.js
        script "data-main": "javascripts/entry_point/#{content.js}", src: "/javascripts/vendor/require.min.js"

      content?.head?()

    body ->
      content?.body?()