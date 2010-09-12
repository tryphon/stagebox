require 'rubygems'

require 'system_builder'
require 'system_builder/box_tasks'

SystemBuilder::BoxTasks.new(:stagebox)
task :buildbot => "stagebox:buildbot"

namespace :stagebox do
  namespace :storage do
    desc "Create storage disk"
    task :create do
      sh "qemu-img create -f qcow2 dist/storage 10G"
    end
  end
end
