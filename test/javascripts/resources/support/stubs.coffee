window.Test ?= {}

# TODO: Sinon-ify this
window.Test.withSelector = (selector, sinonCall) ->
  sinonCall.thisValue.selector.should.equal selector

# ------------------------------------------------------------------------------
# Global Spies
# ------------------------------------------------------------------------------

#Test.original = {}
#Test.original.jQueryReady = $.fn.ready
#
#$.readySubscribers = []
#
#$.fn.ready = (subscriber) ->
#  $.readySubscribers.push subscriber
#  Test.original.jQueryReady.apply($, arguments)
#
#$.callReadySubscribers = ->
#  subscriber() for subscriber in $.readySubscribers

sinon.spy(window, 'require')
sinon.spy(window, 'define')
sinon.spy($, 'ready')

# ------------------------------------------------------------------------------
# Stubbed Libraries
# ------------------------------------------------------------------------------

window.now = {
  subscribers: []
  readySubscribers: []

  ready: (subscriber) ->
    now.readySubscribers.push subscriber

  callReadySubscribers: ->
    for subscriber in now.readySubscribers
      console.log 'subscriber: ', subscriber
      subscriber()

  newClient: ->
}

sinon.spy(now, 'ready')