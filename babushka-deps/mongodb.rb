COMMAND = "mongod --dbpath data\/db --fork --logpath logs\/mongo.log"

def mongo_processes
  processes = `ps -ef | grep "mongo"`.split(/\n/)
  mongo_processes = processes.find_all do |process|
    process[/#{COMMAND}/]
  end
  mongo_processes
end

def mongo_running?
  !mongo_processes.empty?
end

dep 'mongodb' do
  met? {
    which 'mongod' and which 'mongo' and Dir.exists? 'data/db'
  }
  meet {
    `brew install mongodb` unless which 'mongod' and which 'mongo'

    # Create a place to store our local data
    mkdir_if_dne 'data'
    mkdir_if_dne 'data/db'
  }
end

# TODO: Not a very good setup, but eh works for now. Refactor later.
dep 'mongodb-dev' do
  met? {
    File.exists? '.env'
  }
  meet {
    `echo 'MONGOHQ_URL=mongodb://localhost/feelwelllabs/dev' > .env`
  }
end

dep 'mongodb-start' do
  requires 'logs', 'mongodb', 'mongodb-dev'
  met? {
    mongo_running?
  }
  meet {
    `#{COMMAND}`
  }
end

dep 'mongodb-stop' do
  met? {
    !mongo_running?
  }
  meet {
    mongo_processes
    mongo_processes.each do |process|
      pid = process.split(' ')[1].to_i
      `kill #{pid}`
    end
  }
end

dep 'mongodb-restart' do
  requires 'mongodb-stop', 'mongodb-start'
end
