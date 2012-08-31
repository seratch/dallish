# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require "dallish/version"

Gem::Specification.new do |s|
  s.name = "dallish"
  s.version = Dallish::VERSION
  s.authors = ["Kazuhiro Sera"]
  s.email = ["seratch@gmail.com"]
  s.homepage = "https://github.com/seratch/dallish"
  s.summary = %q{An extended Dalli for memcached 1.4.x}
  s.description = %q{An extended Dalli for memcached 1.4.x}

  s.rubyforge_project = "dallish"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 1.9.0'
  s.add_dependency('dalli')

end

