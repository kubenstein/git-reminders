require 'date'

module GitReminders
  class Repo
    TAG_IDENTIFIER = 'rmndr'
    DONE_TAG_IDENTIFIER = 'rmndr'

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
      enhanced_name = "#{TAG_IDENTIFIER}_#{name}__c#{current_time}"
      Tag.create(name: enhanced_name, commit_hash: self.head_commit_hash, editor: true)
    end

    def archive_tag(tag)
      new_name = "#{DONE_TAG_IDENTIFIER}_#{tag.name}__a#{current_time}"
      Tag.create(name: new_name, commit_hash: tag.commit_hash, message: tag.message).tap do |new_tag|
        tag.destroy
      end
    end


    private

    def current_time
      DateTime.now.strftime('%Y-%m-%d_%H-%M')
    end
    
  end
end

