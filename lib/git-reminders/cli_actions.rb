module GitReminders
  class CliActions
    
    def initialize(repo_factory=Repo.new)
      @repo = repo_factory
    end

    def add(name)
      @repo.create_tag(name)
      puts 'Reminder has been created!'
    end

    def list
      @repo.all_runnable_merged_tags.each do |tag|
        puts "#{tag.name}"
      end
    end

    def walk(options={})
      @repo.all_runnable_merged_tags.each do |tag|
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

    def push(remote)
      @repo.push(remote)
    end

    def sync(remote)
      @repo.sync(remote)
    end    


    private 

    def archive_tag_prompt(tag)
      puts 'Do you want to archive this reminder? (Y/N)'
      input = STDIN.gets.upcase.strip
      archive_tag(tag) if input == 'Y'
    end

    def archive_tag(tag)
      @repo.archive_tag(tag)
      puts "Reminder #{tag.name} archived!"
    end

  end
end