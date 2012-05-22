dep 'test' do
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