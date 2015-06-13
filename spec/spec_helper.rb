require 'git-reminders'

Dir[File.expand_path("spec/support/**/*.rb")].each { |f| require f }

module GitReminders
  class Git
    def self.execute(command)
      # silence me...
    end
  end
end