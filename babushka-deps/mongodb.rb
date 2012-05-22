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

dep 'mongodb.start' do
  requires 'logs', 'mongodb', 'mongodb.dev'
  met? {
    mongo_running?
  }
  meet {
    `#{COMMAND}`
  }
end

dep 'mongodb.stop' do
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

dep 'mongodb.restart' do
  refresh = false
  requires 'mongodb.stop', 'mongodb.start'
  met? {
    refresh = false
  }
  meet {
    refresh = true
  }
end
