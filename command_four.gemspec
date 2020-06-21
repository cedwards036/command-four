require_relative 'lib/command_four/version'

Gem::Specification.new do |spec|
  spec.name          = "command_four"
  spec.version       = CommandFour::VERSION
  spec.authors       = ["Christopher Edwards"]
  spec.email         = ["cedwards036@gmail.com"]
  
  spec.summary       = %q{A command-line connect-four game for two players}
  spec.homepage      = "https://github.com/cedwards036/command-four"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/cedwards036/command-four"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = ["command_four"]
  spec.require_paths = ["lib"]
end
