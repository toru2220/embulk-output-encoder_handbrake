
Gem::Specification.new do |spec|
  spec.name          = "embulk-output-encoder_handbrake"
  spec.version       = "0.1.0"
  spec.authors       = ["toru2220"]
  spec.summary       = "Encoder Handbrake output plugin for Embulk"
  spec.description   = "Dumps records to Encoder Handbrake."
  spec.email         = ["toru2220@gmail.com"]
  spec.licenses      = ["MIT"]
  # TODO set this: spec.homepage      = "https://github.com/toru2220/embulk-output-encoder_handbrake"

  spec.files         = `git ls-files`.split("\n") + Dir["classpath/*.jar"]
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ["lib"]

  #spec.add_dependency 'YOUR_GEM_DEPENDENCY', ['~> YOUR_GEM_DEPENDENCY_VERSION']
  spec.add_development_dependency 'embulk', ['>= 0.9.18']
  spec.add_development_dependency 'bundler', ['>= 1.10.6']
  spec.add_development_dependency 'rake', ['>= 10.0']
end
