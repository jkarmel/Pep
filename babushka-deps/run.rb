require_relative 'utils.rb'

dep 'run' do
  requires 'foreman', 'mongodb-start'
  met? {
    ping
  }
  meet {
    view_localhost
    system("foreman run coffee app.coffee")
  }
end

dep 'watch' do
  requires 'foreman', 'supervisor', 'mongodb-start'
  met? {
    ping
  }
  meet {
    view_localhost
    system("foreman run supervisor app.coffee")
  }
end