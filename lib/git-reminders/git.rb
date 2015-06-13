require 'date'

module GitReminders
  class Git
    def self.execute(command)
      %x["#{command}"]
    end
  end
end

