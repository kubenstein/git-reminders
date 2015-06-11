require 'thor'

class GitReminderCLI < Thor

  desc 'add NAME', 'Create reminder with given name. Reminder will be created on current head position'
  def add(name)
  end

  desc 'list', 'Display all waiting reminders valid for current branch'
  def list
  end

  desc 'walk', 'Display all valid reminders one by one'
  option 'prompt-delete', type: :boolean
  def walk
  end

  desc 'sync REMOTE', 'Sync all reminders with remote server'
  def sync(remote)
  end

end

GitReminderCLI.start(ARGV)