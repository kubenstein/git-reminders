# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'git-reminders/version'

Gem::Specification.new do |spec|
  spec.name          = "git-reminders"
  spec.version       = GitReminders::VERSION
  spec.authors       = ["Jakub Niewczas"]
  spec.email         = ["niewczas.jakub@gmail.com"]

  spec.summary       = ""
  spec.description   = ""
  # spec.homepage      = "Put your gem's website or public repo URL here."


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ["git-reminder"] 
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
