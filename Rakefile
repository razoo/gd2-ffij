require 'bundler'
require 'rubygems'

require 'rake'
require 'rake/testtask'

Bundler::GemHelper.install_tasks

desc 'Test GD2 interface'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end
