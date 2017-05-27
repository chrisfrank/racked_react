Gem::Specification.new do |spec|
  spec.name          = 'racked_react'
  spec.version       = '0.0.1'
  spec.authors       = ['chrisfrankdotfm']
  spec.email         = ['chris.frank@thefutureproject.org']
  spec.description   = 'Serve your static React apps with Rack'
  spec.summary       = 'Serve your static React apps with Rack'
  spec.homepage      = 'https://github.com/chrisfrank/rack-react-server'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($RS)
  spec.test_files    = spec.files.grep('^(spec)/')
  spec.require_path = 'lib'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rack-test'

  spec.add_dependency 'rack'
end
