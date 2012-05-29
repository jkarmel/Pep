def ping
  alive = true

  begin
    Net::HTTP.get(URI("http://localhost:3000/"))
  rescue
    alive = false
  end

  alive
end

dep 'run' do
  requires 'foreman', 'mongodb-start'
  met? {
    ping
  }
  meet {
    t = Thread.new do
      sleep(1)
      `open http://localhost:3000`
    end
    system("foreman run coffee app.coffee")
  }
end

dep 'watch' do
  requires 'foreman', 'supervisor', 'mongodb-start'
  met? {
    ping
  }
  meet {
    t = Thread.new do
      sleep(1)
      `open http://localhost:3000`
    end
    system("foreman run supervisor app.coffee")
  }
end