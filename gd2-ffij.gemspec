# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gd2-ffij/version"

Gem::Specification.new do |s|
  s.name        = "gd2-ffij"
  s.version     = Gd2::Gd2FFIJ::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["J Smith"]
  s.email       = ["dark.panda@gmail.com"]
  s.homepage    = "http://github.com/dark-panda/gd2-ffij"
  s.summary     = %q{gd2-ffij is a refactoring of the Ruby/Gd2 library implemented with FFI}
  s.description = %q{gd2-ffij is a refactoring of the Ruby/Gd2 library implemented with FFI}

  s.add_dependency 'ffi'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
