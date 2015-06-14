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
      GitWrapper.tag_commit_hash(self.name)
    end

    def message
      GitWrapper.tag_message(self.name)
    end

    def appeared_in_branches
      GitWrapper.branches_that_contains(self.commit_hash)
    end

    def destroy
      GitWrapper.destroy_tag(self.name)
    end


    private

    def self.create_tag_with_message_from_editor(name, commit_hash)
      GitWrapper.create_tag_with_message_from_editor(name, commit_hash)
    end

    def self.create_tag_with_message(name, commit_hash, message)
      GitWrapper.create_tag_with_message(name, commit_hash, message)
      Tag.new(name)
    end

  end

end

