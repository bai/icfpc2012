# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'icfpc2012/version'
require "find"

Gem::Specification.new do |s|
  s.name          = "icfpc2012"
  s.version       = Icfpc2012::VERSION
  s.authors       = ["8 people"]
  s.email         = ["8 emails"]
  s.homepage      = "https://github.com/bai/icfpc2012"
  s.summary       = "ICFPC 2012 task"
  s.description   = "ICFPC 2012 task"

  s.files = %w(README.md Rakefile icfpc2012.gemspec)
  s.files += Dir.glob("lib/**/*.rb")
  s.files += Dir.glob("bin/**/*")
  s.files += Dir.glob("maps/**/*")
  s.files += Dir.glob("test/**/*")
  s.bindir = 'bin'
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'
  s.executables = %w(pater solve vmap)

  s.add_development_dependency 'minitest'
  s.add_dependency 'logger'
  s.add_dependency 'active_support'
end
