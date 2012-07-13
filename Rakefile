require 'rake'
require 'rake/testtask'

require 'bundler'
Bundler::GemHelper.install_tasks

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

task :default => :test
