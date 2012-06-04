define ->
  now.subscribers = []
  now.update = (customer) ->
    subscriber(customer) for subscriber in now.subscribers