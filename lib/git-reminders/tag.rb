require 'ostruct'
require 'tempfile'

module GitReminders
  class Tag < Struct.new(:name)

    def self.create(params = {})
      name = params[:name]
      commit_hash = params[:commit_hash]
      message = params[:message]
      editor = params[:editor]

      tag_name = "#{name}_#{Time.now.to_i}"

      if editor
        create_tag_with_message_from_editor(tag_name, commit_hash)
      else
        create_tag_with_message(tag_name, commit_hash, message)
      end
    end

    def commit_hash
      `git cat-file tag #{self.name} | grep object | cut -d" " -f2`.strip
    end

    def message
      `git cat-file tag #{self.name}`.split("\n\n")[1]
    end

    def appeared_in_branches
      `git branch --contains #{self.commit_hash}`.gsub('*', ' ').split("\n").map(&:strip)
    end

    def destroy
      `git tag -d #{self.name}`
    end


    private

    def self.create_tag_with_message_from_editor(name, commit_hash)
      system("git tag -a #{name} #{commit_hash}")
    end

    def self.create_tag_with_message(name, commit_hash, message)
      t = Tempfile.new(name)
      t.write(message)
      t.flush
      `git tag -a -F #{t.path} #{name} #{commit_hash}`
      t.close
      Tag.new(name)
    end
  end

end

