require 'date'

module GitReminders
  class Repo
    TAG_IDENTIFIER = 'rmndr'
    DONE_TAG_IDENTIFIER = 'DONE'

    def current_branch
      `git branch | grep "*" | cut -d" " -f2`.strip
    end

    def head_commit_hash
      `git log --oneline -n1 | cut -d" " -f1`.strip
    end

    def all_tags_with_identifier(identifier)
      all_tags_names_with_identifier(identifier).map do |name|
        Tag.new(name)
      end
    end

    def all_runnable_merged_tags
      all_tags_with_identifier(TAG_IDENTIFIER).select do |tag|
        tag.appeared_in_branches.include?(current_branch)
      end
    end

    def sync(remote)
      # algorithm:
      # 1) fetch all tags from repo
      # 2) remove all LOCAL and REMOTE not-archived twin tags that are LOCALLY marked as archived
      # 3) push all tags back to origin
      # !4) remove all LOCAL tags that were removed on REMOTE but somehow still are LOCALLY
      # ! this doesnt work since in 3) we pushed all local stuff to remote again 
      

      `git fetch --tags #{remote}`
      all_runnable_tags = all_tags_with_identifier(TAG_IDENTIFIER)

      all_tags_with_identifier(DONE_TAG_IDENTIFIER).each do |done_tag|
        all_runnable_tags.each do |tag_before_archiving|
          if done_tag.name =~ /#{tag_before_archiving.name}/
            `git push #{remote} :#{tag_before_archiving.name}`
            `git tag -d #{tag_before_archiving.name}`
          end
        end
      end
      `git push --tags #{remote}`
      `git fetch --prune #{remote} +refs/tags/*:refs/tags/*`
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

    def all_tags_names_with_identifier(identifier)
      `git tag -l #{identifier}*`.split
    end

    def current_time
      DateTime.now.strftime('%Y-%m-%d_%H-%M')
    end
    
  end
end

