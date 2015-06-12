module GitReminders
  class Repo
    def current_branch
      `git branch | grep "*" | cut -d" " -f2`.strip
    end

    def all_runnable_tags_names 
      `git tag -l runme*`.split
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

    def rename_tag(tag, new_name)
      Tag.create(name: new_name, commit_hash: tag.commit_hash, executable_code: tag.executable_code).tap do |new_tag|
        tag.destroy
      end
    end
    
  end
end

