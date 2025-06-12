# frozen_string_literal: true

require_relative "lib/prawndown/version"

Gem::Specification.new do |spec|
  spec.name = "prawndown-ext"
  spec.version = PrawndownExt::Ext::VERSION
  spec.authors = ["PunishedFelix"]
  spec.email = ["labadore1844@gmail.com"]

  spec.summary = "Extension of Prawndown to include additional features, such as customizing text fonts, sizes, and support for images and quotes."
  spec.description = "Extension of Prawndown to include additional Markdown features. Currently supports custom header sizes, fonts, and other properties; removing iframe content, and support for images and quotes."
  spec.homepage = "https://github.com/badgernested/prawndown-ext"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.files = ["lib/prawndown-ext.rb", "lib/prawndown/parser.rb", "lib/prawndown/version.rb"]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "prawn", "~> 2.5", ">= 2.5.0"

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
