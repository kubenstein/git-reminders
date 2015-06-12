module GitReminders
  class Repo
    TAG_IDENTIFIER = 'rmndr'

    def current_branch
      `git branch | grep "*" | cut -d" " -f2`.strip
    end

    def head_commit_hash
      `git log --oneline -n1 | cut -d" " -f1`.strip
    end

    def all_runnable_tags_names 
      `git tag -l #{TAG_IDENTIFIER}*`.split
    end

    def all_runnable_tags
      all_runnable_tags_names.map do |name|
        Tag.new(name)
      end
    end

    def all_runnable_merged_tags
      all_runnable_tags.select do |tag|
        tag.appeared_in_branches.include?(current_branch)
      end
    end

    def create_tag(name)
      tag_name = "#{TAG_IDENTIFIER}_#{name}"
      Tag.create(name: tag_name, commit_hash: self.head_commit_hash, editor: true)
    end

    def rename_tag(tag, name)
      tag_name = "#{TAG_IDENTIFIER}_#{name}"
      Tag.create(name: tag_name, commit_hash: tag.commit_hash, executable_code: tag.executable_code).tap do |new_tag|
        tag.destroy
      end
    end
    
  end
end

