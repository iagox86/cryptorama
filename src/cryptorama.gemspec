lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'cryptorama'
  spec.version       = '0.0.0'
  spec.authors       = ['iagox86']
  spec.email         = ['ron-git@skullsecurity.org']

  spec.summary       = 'A crypto workshop'
  spec.description   = 'A series of crypto-based challenges'
  spec.homepage      = 'https://github.com/iagox86/cryptorama'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler',   '~> 1.11'
  spec.add_development_dependency 'rake',      '~> 10.0'
  spec.add_development_dependency 'simplecov', '~> 0.14.1'
  spec.add_development_dependency 'test-unit', '~> 3.2.8'

  spec.add_dependency 'base32',     '~> 0.3.2'
  spec.add_dependency 'hexhelper',  '~> 0.0.2'
  spec.add_dependency 'singlogger', '~> 0.0.0'
  spec.add_dependency 'optimist', '~> 3.0.0'
  spec.add_dependency 'salsa20', '~> 0.1.3'
end
