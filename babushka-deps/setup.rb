def mkdir_if_dne(path)
  Dir.mkpath path unless Dir.exists? path
end

def resource?(path)
  File.exists? path or File.symlink? path 
end

def ln_if_dne(source, destination)
  `ln -s #{Dir.pwd + '/' + source} #{destination}` unless resource? destination
end

dep 'mongodb' do
  VERSION = '2.0.5'
  FLAVOR = "mongodb-osx-x86_64-#{VERSION}"
  
  met? {
    which 'mongod' and which 'mongo' and Dir.exists? 'data/db'  
  }
  meet {
    unless which 'mongod' and which 'mongo'
      # Install Mongo
      unless Dir.exists? "/local/mongodb-#{VERSION}"
        Dir.chdir('/local') {
          `curl http://fastdl.mongodb.org/osx/#{FLAVOR}.tgz > mongodb.tgz`
          `tar xzf mongodb.tgz`
          `mv #{FLAVOR} mongodb-#{VERSION}`  
          
          # Cleanup
          `rm mongodb.tgz`
        }
      end

      # Create a symbolic link to all executables
      `ln -s /local/mongodb-#{VERSION}/bin/* /local/bin/`
    end

    # Create a place to store our local data
    mkdir_if_dne 'data'
    mkdir_if_dne 'data/db'
  }
end

dep 'logs' do
  met? {
    Dir.exists? 'logs'
  } 
  meet {
    Dir.mkdir 'logs'
  }
end

# Always run this once
# TODO: How can we figure out whether to run this or not?
dep 'npm.refresh' do
  refresh = false
  requires 'core:nodejs.src', 'core:npm'
  met? {
   refresh 
  }
  meet {
    `npm install`
    `npm update`
    refresh = true
  }
end

dep 'supervisor' do
  requires 'core:nodejs.src', 'core:npm'
  met? {
    which 'supervisor'
  }
  meet {
    sudo 'npm install -g supervisor'
  }
end

dep 'coffee-script' do
  requires 'core:nodejs.src', 'core:npm'
  met? {
    which 'coffee'
  }
  meet {
    sudo 'npm install -g coffee-script'
  }
end

dep 'foreman' do
  requires 'core:rubygems'
  met? {
    which 'foreman'
  }
  meet {
    sudo 'gem install foreman'
  }
end

# TODO: Not a very good setup, but eh works for now. Refactor later.
dep 'mongodb.dev' do
  met? {
    File.exists? '.env'
  }
  meet {
    `echo 'MONGOHQ_URL=mongodb://localhost/feelwelllabs/dev' > .env` 
  }
end

dep 'setup.testing' do
  TESTING_RESOURCES = [
    ['public/javascripts/', 'test/public/javascripts'],
    ['node_modules/mocha/mocha.js', 'test/public/vendor/mocha.js'],
    ['node_modules/mocha/mocha.css', 'test/public/vendor/mocha.css'],
    ['node_modules/chai/chai.js', 'test/public/vendor/chai.js'],
    ['node_modules/sinon/lib/sinon.js', 'test/public/vendor/sinon.js'],
    ['node_modules/sinon-chai/lib/sinon-chai.js', 'test/public/vendor/sinon-chai.js']
  ]

  requires 'npm.refresh'
  met? {
    TESTING_RESOURCES.inject(true) { |all_exist, resource| all_exist and resource? resource[1] }
  }
  meet {
    mkdir_if_dne 'test/public/vendor'
    TESTING_RESOURCES.each do |resource|
      ln_if_dne resource[0], resource[1]
    end
  }
end

# TODO: Do everything in /local, right now nodejs and git installed to /usr/local 
# (which requires a password and is annoying) 
dep 'setup' do
  requires 'core:git', 'core:nodejs.src', 'core:npm', 'mongodb', 
           'logs', 'npm.refresh', 'supervisor', 'foreman', 'mongodb.dev',
           'setup.testing', 'coffee-script'
  met? {
    true
  }
  meet {
  }
end
