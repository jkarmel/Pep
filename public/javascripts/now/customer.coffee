define ->
  now.subscribers = []
  now.update = (customerDoc) ->
    subscriber(customerDoc) for subscriber in now.subscribers