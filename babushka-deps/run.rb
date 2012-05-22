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
  requires 'foreman', 'mongodb.start'
  met? {
    ping
  }
  meet {
    system("foreman run coffee app.coffee")
  }
end

dep 'watch' do
  requires 'foreman', 'supervisor', 'mongodb.start'
  met? {
    ping
  }
  meet {
    system("foreman run supervisor app.coffee")
  }
end