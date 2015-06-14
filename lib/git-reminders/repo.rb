require 'date'

module GitReminders
  class Repo
    TAG_IDENTIFIER = 'rmndr'
    DONE_TAG_IDENTIFIER = 'DONE'

    def head_commit_hash
      GitWrapper.head_commit_hash
    end

    def all_runnable_merged_tags
      all_tags_with_identifier(TAG_IDENTIFIER).select do |tag|
        tag.appeared_in_branches.include?(GitWrapper.current_branch)
      end
    end

    def sync(remote)
      GitWrapper.fetch_prune_tags(remote)
    end

    def push(remote)
      # algorithm:
      # 1) fetch all tags from repo
      # 2) remove all LOCAL and REMOTE not-archived twin tags that are LOCALLY marked as archived
      # 3) push all tags back to origin

      GitWrapper.fetch_tags(remote)
      all_runnable_tags = all_tags_with_identifier(TAG_IDENTIFIER)

      all_tags_with_identifier(DONE_TAG_IDENTIFIER).each do |done_tag|
        all_runnable_tags.each do |tag_before_archiving|
          if done_tag.name =~ /#{tag_before_archiving.name}/
            GitWrapper.remove_remote_tag(remote, tag_before_archiving.name)
            GitWrapper.remove_local_tag(tag_before_archiving.name)
          end
        end
      end
      GitWrapper.push_tags(remote)
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
      GitWrapper.tags_with_identifier(identifier)
    end

    def all_tags_with_identifier(identifier)
      all_tags_names_with_identifier(identifier).map do |name|
        Tag.new(name)
      end
    end

    def current_time
      DateTime.now.strftime('%Y-%m-%d_%H-%M')
    end
    
  end
end

