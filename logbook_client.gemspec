# frozen_string_literal: true

require_relative 'lib/logbook_client/version'

Gem::Specification.new do |spec|
  spec.name = 'logbook_client'
  spec.version = LogbookClient::VERSION
  spec.authors = ['André Rodrigues']
  spec.email = ['andrerpbts@gmail.com']

  spec.summary = 'Ruby SDK for CXP LogBook service'
  spec.homepage = 'https://github.com/CollateralXP/logbook_client'
  spec.required_ruby_version = '>= 3.3.4'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/CollateralXP/logbook_client'
  spec.metadata['changelog_uri'] =
    'https://github.com/CollateralXP/logbook_client/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) ||
        f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_dependency 'http', '~> 5.2'
end
