
require 'thor'

module GitReminders
  class Cli < Thor
    default_task :list


    desc 'add NAME', 'Create reminder with given name. Reminder will be created on current head position'
    def add(name)
      CliActions.new.add(name)
    end


    desc 'list', 'Display all waiting reminders valid for current branch'
    def list
      CliActions.new.list
    end


    desc 'walk', 'Display all valid reminders one by one'
    option 'no-prompt', type: :boolean
    option 'archive-prompt', type: :boolean
    option 'auto-archive', type: :boolean
    def walk
      CliActions.new.walk(options)
    end


    desc 'push REMOTE', 'Push all reminders (created or archived) to remote server. '
    def push(remote)
      CliActions.new.push(remote)
    end

    desc 'sync REMOTE', 'Cleanup all local reminders and fetch them again from REMOTE server.'
    def sync(remote)
      CliActions.new.sync(remote)
    end    

  end
end