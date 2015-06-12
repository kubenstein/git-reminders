require 'ostruct'
require 'tempfile'

module GitReminders
  class Tag < Struct.new(:name)

    def self.create(params = {})
      name = params[:name]
      commit_hash = params[:commit_hash]
      executable_code = params[:executable_code]

      t = Tempfile.new(name)
      t.write(executable_code)
      t.flush
      `git tag -a -F #{t.path} #{name} #{commit_hash}`
      t.close
      Tag.new(name)
    end

    def commit_hash
      `git cat-file tag #{self.name} | grep object | cut -d" " -f2`.strip
    end

    def executable_code
      `git cat-file tag #{self.name}`.split("\n\n")[1]
    end

    def appeared_in_branches
      `git branch --contains #{self.commit_hash}`.gsub('*', ' ').split("\n").map(&:strip)
    end

    def destroy
      `git tag -d #{self.name}`
    end
  end

# gitrepo = GitRepo.new
# gitrepo.all_runnable_merged_tags.each do |tag|
#   puts "\n\n++++++++++++++++"
#   puts tag.executable_code
#   puts "++++++++++++++++"
#   puts "archive this instruction? (Y/N)"
#   if gets.strip == 'Y'
#     puts "#{tag.name} archived!"
#     gitrepo.rename_tag(tag, "done_#{tag.name}")
#   end
# end

end

