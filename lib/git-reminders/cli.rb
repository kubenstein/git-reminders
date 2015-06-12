
require 'thor'

module GitReminders
  class Cli < Thor
    default_task :list

    desc 'add NAME', 'Create reminder with given name. Reminder will be created on current head position'
    def add(name)
    end

    desc 'list', 'Display all waiting reminders valid for current branch'
    def list
      Repo.new.all_runnable_merged_tags.each do |tag|
        puts "#{tag.name}"
      end
    end

    desc 'walk', 'Display all valid reminders one by one'
    option 'prompt-delete', type: :boolean
    def walk
    end

    desc 'sync REMOTE', 'Sync all reminders with remote server'
    def sync(remote)
    end

  end
end