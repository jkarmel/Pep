def mkdir_if_dne(path)
  Dir.mkdir path unless Dir.exists? path
end

def resource?(path)
  File.exists? path or File.symlink? path
end

def get_resource_if_dne(source, destination)
  unless resource? destination
    if /^http/.match source
      puts source, destination
      `curl #{source} > #{destination}`
    else
      absolute_source = Dir.pwd + '/' + source
      `ln -s #{absolute_source} #{destination}`
    end
  end
end

dep 'logs' do
  met? {
    Dir.exists? 'logs'
  } 
  meet {
    Dir.mkdir 'logs'
  }
end

# TODO: How can we figure out whether to run this or not? Use `npm outdated`
dep 'npm-refresh.task' do
  requires 'core:nodejs.src', 'core:npm'
  run {
    `npm install`
    `npm update`
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

dep 'add-to-path' do 
  ["#{ENV['HOME']}/.bash_profile", "#{ENV['HOME']}/.zhsrc"].each do |fname|
    File.open(fname, "a+") {|f|
      2.times {f.puts()}
      f.puts "PATH=/usr/local/bin:/usr/local:$PATH"
    }
  end
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

dep 'phantomjs' do
  met? { which 'phantomjs' }
  meet { `brew install phantomjs` }
end

dep 'casperjs' do
  VERSION = '0.6.8'

  met? { which 'casperjs' }
  meet {
    mkdir_if_dne '/usr/local/casperjs'
    Dir.chdir('/usr/local/casperjs') {
      sudo "git clone git://github.com/n1k0/casperjs.git ."
      sudo "git checkout tags/#{VERSION}"
      sudo "ln -sf `pwd`/bin/casperjs /usr/local/bin/casperjs"
    }
  }
end

dep 'setup-testing' do
  RESOURCES_DIR = "test/js/resources"

  TESTING_RESOURCES = [
    ['public/js/', "#{RESOURCES_DIR}/js"],
    ['node_modules/mocha/mocha.js', "#{RESOURCES_DIR}/support/mocha.js"],
    ['node_modules/mocha/mocha.css', "#{RESOURCES_DIR}/support/mocha.css"],
    ['node_modules/chai/chai.js', "#{RESOURCES_DIR}/support/chai.js"],
    # TODO: Check the npm package version and pull that one!
    ['http://sinonjs.org/releases/sinon-1.3.4.js', "#{RESOURCES_DIR}/support/sinon.js"],
    ['node_modules/sinon-chai/lib/sinon-chai.js', "#{RESOURCES_DIR}/support/sinon-chai.js"],
    ['https://raw.github.com/chaijs/chai-jquery/master/chai-jquery.js', "#{RESOURCES_DIR}/support/chai-jquery.js"]
  ]

  requires 'npm-refresh.task', 'casperjs'
  met? {
    TESTING_RESOURCES.all? { |resource| resource? resource[1] }
  }
  meet {
    mkdir_if_dne RESOURCES_DIR
    mkdir_if_dne "#{RESOURCES_DIR}/support"
    TESTING_RESOURCES.each do |resource|
      get_resource_if_dne resource[0], resource[1]
    end
  }
end

dep 'setup' do
  requires 'core:homebrew', 'core:git', 'core:nodejs.src', 'core:npm', 'mongodb',
           'logs', 'npm-refresh.task', 'supervisor', 'foreman', 'mongodb-dev',
           'setup-testing', 'coffee-script'
end
