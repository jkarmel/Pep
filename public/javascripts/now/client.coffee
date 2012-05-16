define ->
  now.subscribers = []
  now.update = (clientDoc) ->
    subscriber(clientDoc) for subscriber in now.subscribers