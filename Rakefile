require 'rubygems'

require 'system_builder'
require 'system_builder/box_tasks'

SystemBuilder::BoxTasks.new(:stagebox) do |box|
  box.boot do |boot|
    boot.version = :wheezy
    boot.architecture = :amd64
  end
end

desc "Run continuous integration tasks (spec, ...)"
task :ci => "stagebox:buildbot"
