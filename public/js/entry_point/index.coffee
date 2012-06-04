Index = {
  setup: (Session) ->
    Index.Session = Session
    $(document).ready ->
      now.ready ->
        Index.main()

  main: ->
    $("#start-button").removeClass('loading').removeClass('disabled')
      .click @loadSession

  loadSession: =>
    $('#content').html ''
    now.newCustomer()
    $('#content').append new Index.Session now
}

define ['/js/ui/session.html.js', '/js/now/customer.js'],
        Index.setup

window.Testable?.Index = Index