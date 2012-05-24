dep 'git-pull.task' do
  requires 'core:git'

  run {
    `git pull --rebase`
  }
end

dep 'update' do
  requires 'git-pull.task', 'npm-refresh.task'
end