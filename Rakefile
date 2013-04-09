require 'rubygems'

require 'system_builder'
require 'system_builder/box_tasks'

SystemBuilder::BoxTasks.new(:stagebox) do |box|
  box.boot do |boot|
    boot.version = :squeeze
  end

  box.disk_image do |image|
    image.size = 500.megabytes
  end
end

desc "Run continuous integration tasks (spec, ...)"
task :ci => "stagebox:buildbot"

namespace :stagebox do
  namespace :storage do
    desc "Create storage disk"
    task :create do
      sh "qemu-img create -f raw dist/storage 10G"
    end
  end
end
