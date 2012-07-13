# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'icfpc2012/version'

Gem::Specification.new do |s|
  s.name          = "icfpc2012"
  s.version       = Icfpc2012::VERSION
  # s.authors       = ["Vlad Gorodetsky"]
  # s.email         = ["v@gor.io"]
  s.homepage      = "https://github.com/bai/icfpc2012"
  s.summary       = "ICFPC 2012 task"
  s.description   = "ICFPC 2012 task"

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'
end
