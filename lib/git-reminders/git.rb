require 'date'

module GitReminders
  class Git

    def self.branches_that_contains(commit_hash)
      execute("git branch --contains #{commit_hash}").
          gsub('*', ' ').
          split("\n").
          map(&:strip).
          reject { |branch| branch.empty? }
    end

    def self.fetch_tags(remote)
      execute("git fetch --tags #{remote}")
    end

    def self.push_tags(remote)
      execute("git push --tags #{remote}")
    end

    def self.remove_remote_tag(remote, tag_name)
      execute("git push #{remote} :#{tag_name}")
    end
    def self.remove_local_tag(tag_name)
      execute("git tag -d #{tag_name}")
    end

    def self.head_commit
      execute('git log --oneline -n1')
    end

    def self.current_branch
      execute('git branch').
          match(/^[\*][\s*](?<current_branch>[^\n]*)/)['current_branch']
    end

    def self.fetch_prune_tags(remote)
      execute("git fetch --prune #{remote} +refs/tags/*:refs/tags/*")
    end

    def self.tags_with_identifier(identifier)
      execute("git tag -l #{identifier}*").split
    end

    def self.tag_commit_hash(tag_name)
      execute("git cat-file tag #{tag_name}").
          match(/object[\s]*(?<commit_hash>[^\s]*)/)['commit_hash']
    end

    def self.tag_message(tag_name)
      execute("git cat-file tag #{tag_name}").
          split("\n\n")[1].
          strip
    end

    def self.create_tag_with_message_from_editor(name, commit_hash)
      Kernel.system("git tag -a #{name} #{commit_hash}")
    end

    def self.create_tag_with_message(name, commit_hash, message)
      t = Tempfile.new(name)
      t.write(message)
      t.flush
      execute("git tag -a -F #{t.path} #{name} #{commit_hash}")
      t.close
    end

    def self.destroy_tag(tag_name)
      execute("git tag -d #{tag_name}")
    end

    def self.execute(command)
      %x["#{command}"]
    end
  end
end

