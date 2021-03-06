require_relative 'utils.rb'

def with_running(command, wait = 0)
  pid = fork {exec command}
  sleep wait
  yield
  `kill #{pid}`
end

TEST_APP_COMMAND = "coffee test/js/app.coffee"

dep 'test.browser' do
  met? {
    processes = `ps -ef | grep "coffee"`.split(/\n/)
    ping(1337) and processes.any? do |process|
      process[/#{TEST_APP_COMMAND}/]
    end
  }
  meet {
    view_localhost 1337
    system TEST_APP_COMMAND
  }
end

dep 'test.client.task' do
  requires 'casperjs'

  run {
    with_running(TEST_APP_COMMAND, 1) do
      system "casperjs test/js/all.spec.coffee"
    end
  }
end

dep 'test.backend.task' do
  requires 'mongodb-start'

  run {
    test_dirs = "test/app.spec.coffee"
    Dir.foreach 'test' do |resource|
      unless resource[/\./] or resource == 'js'
        test_dirs += " test/#{resource}/*"
      end
    end

    system "MONGOHQ_URL=mongodb://localhost/feelwelllabs/test ./node_modules/.bin/mocha #{test_dirs}"
  }
end

dep 'test' do
  requires 'test.client.task', 'test.backend.task'
end