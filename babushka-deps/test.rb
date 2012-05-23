dep 'test.browser' do
  COMMAND = "coffee test/javascripts/app.coffee"

  met? {
    processes = `ps -ef | grep "coffee"`.split(/\n/)
    processes.any? do |process|
      process[/#{COMMAND}/]
    end
  }
  meet {
    t = Thread.new do
      sleep(1)
      `open http://localhost:1337`
    end
    system COMMAND
  }
end

dep 'test.client' do
  is_run = false

  met? {
    is_run
  }
  meet {
    system "./node_modules/.bin/mocha -t 10000 test/javascripts/all.spec.coffee"
    is_run = true
  }
end

dep 'test.backend' do
  requires 'mongodb.start'
  is_run = false

  met? {
    is_run
  }
  meet {
    test_dirs = ""
    Dir.foreach 'test' do |resource|
      unless resource[/\./] or resource == 'javascripts'
        test_dirs += "test/#{resource}/* "
      end
    end

    system "MONGOHQ_URL=mongodb://localhost/feelwelllabs/test ./node_modules/.bin/mocha #{test_dirs}"
    is_run = true
  }
end

dep 'test' do
  is_run = false
  requires 'test.client', 'test.backend'
  met? {
    is_run
  }
  meet {
    is_run = true
  }
end