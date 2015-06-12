
require 'thor'

module GitReminders
  class Cli < Thor
    default_task :list


    desc 'add NAME', 'Create reminder with given name. Reminder will be created on current head position'
    def add(name)
      Repo.new.create_tag(name)
      puts "Reminder has been created!"
    end


    desc 'list', 'Display all waiting reminders valid for current branch'
    def list
      Repo.new.all_runnable_merged_tags.each do |tag|
        puts "#{tag.name}"
      end
    end


    desc 'walk', 'Display all valid reminders one by one'
    option 'no-prompt', type: :boolean
    option 'archive-prompt', type: :boolean
    option 'auto-archive', type: :boolean
    def walk
      Repo.new.all_runnable_merged_tags.each do |tag|
        puts "** reminder: #{tag.name} **\n\n"
        puts "#{tag.message}\n"

        unless options['no-prompt']          
          if options['archive-prompt']
            archive_tag_prompt(tag)
          else
            STDIN.gets
          end
        end

        if options['auto-archive']
          archive_tag(tag)
        end
          
      end
    end


    desc 'sync REMOTE', 'Sync all reminders with remote server'
    def sync(remote)
      Repo.new.sync(remote)
    end


    private 

    def archive_tag_prompt(tag)
      puts "Do you want to archive this reminder? (Y/N)"
      input = STDIN.gets.upcase.strip
      archive_tag(tag) if input == 'Y'
    end

    def archive_tag(tag)
      Repo.new.archive_tag(tag)
      puts "Reminder #{tag.name} archived!"
    end

  end
end