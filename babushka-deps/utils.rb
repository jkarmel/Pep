def ping port = 3000
  alive = true

  begin
    Net::HTTP.get(URI("http://localhost:#{port}/"))
  rescue
    alive = false
  end

  alive
end

def view_localhost port = 3000, delay = 1
  t = Thread.new do
    sleep(delay)
    `open http://localhost:#{port}`
  end
end