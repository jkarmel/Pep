application
  js: "index.js"
  body: ->
    h1 ->
      img src: '/images/logo.png'
    center ->
      input '#start-button.loading.disabled', type: 'button', value: 'Get it now with Jeremy as your guide &rarr;'