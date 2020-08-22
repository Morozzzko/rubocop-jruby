# frozen_string_literal: true

require_relative 'lib/rubocop/jruby/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubocop-jruby'
  spec.version       = RuboCop::JRuby::VERSION
  spec.authors       = ['Igor S. Morozov']
  spec.email         = ['igor@morozov.is']

  spec.summary       = 'A collection of rules and fixers for JRuby'
  spec.homepage      = 'https://github.com/Morozzzko/rubocop-jruby'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Morozzzko/rubocop-jruby'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rubocop'
end
