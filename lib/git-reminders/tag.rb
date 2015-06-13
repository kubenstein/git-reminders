require 'ostruct'
require 'tempfile'

module GitReminders
  class Tag < Struct.new(:name)

    def self.create(params = {})
      name = params[:name]
      commit_hash = params[:commit_hash]
      message = params[:message]
      editor = params[:editor]

      if editor
        create_tag_with_message_from_editor(name, commit_hash)
      else
        create_tag_with_message(name, commit_hash, message)
      end
    end

    def commit_hash
      Git.execute("git cat-file tag #{self.name}").
          match(/object[\s]*(?<commit_hash>[^\s]*)/)['commit_hash']
    end

    def message
      Git.execute("git cat-file tag #{self.name}").
          split("\n\n")[1].
          strip
    end

    def appeared_in_branches
      Git.execute("git branch --contains #{self.commit_hash}").
          gsub('*', ' ').split("\n").
          map(&:strip).
          reject { |branch| branch.empty? }
    end

    def destroy
      Git.execute("git tag -d #{self.name}")
    end


    private

    def self.create_tag_with_message_from_editor(name, commit_hash)
      Kernel.system("git tag -a #{name} #{commit_hash}")
    end

    def self.create_tag_with_message(name, commit_hash, message)
      t = Tempfile.new(name)
      t.write(message)
      t.flush
      Git.execute("git tag -a -F #{t.path} #{name} #{commit_hash}")
      t.close
      Tag.new(name)
    end


  end

end

