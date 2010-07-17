require 'rubygems'

require 'system_builder'
require 'system_builder/task'

load './local.rb' if File.exists?("./local.rb")

release_number = Time.now.strftime('%Y%m%d-%H%M')
release_name = "stagebox-#{release_number}"

boot = SystemBuilder::DebianBoot.new("build/root")
boot.configurators << SystemBuilder::PuppetConfigurator.new(:release_name => release_name)

SystemBuilder::Task.new(:stagebox) do
  SystemBuilder::DiskSquashfsImage.new("dist/disk").tap do |image|
    image.boot = boot
		image.size = 500.megabytes
  end
end

SystemBuilder::Task.new(:"stagebox-demo") do
  SystemBuilder::IsoSquashfsImage.new("dist/iso").tap do |image|
    image.boot = boot
  end
end

desc "Setup your environment to build a stagebox image"
task :setup => "stagebox:setup" do
  if ENV['WORKING_DIR']
    %w{build dist}.each do |subdir|
      working_subdir = File.join ENV['WORKING_DIR'], subdir
      puts "* create and link #{working_subdir}"
      mkdir_p working_subdir
      ln_sf working_subdir, subdir
    end
  end
end

task :clean do
  sh "sudo sh -c \"fuser $PWD/build/root || rm -r build/root\"" if File.exists?("build/root")
  rm_rf "dist"
  mkdir_p "dist"
end

def create_latest_file(latest_file, release_name, release_number)
  checksum = %x{sha256sum dist/upgrade.tar}.split.first
  File.open(latest_file, "w") do |f|
    f.puts "name: #{release_name}"
    f.puts "url: http://download.tryphon.eu/stagebox/stagebox-#{release_number}.tar"
    f.puts "checksum: #{checksum}"
    f.puts "status_updated_at: #{Time.now}"
    f.puts "description_url: http://www.tryphon.eu/release/#{release_name}"
  end
end

namespace :buildbot do
  task :dist do
    mkdir_p target_directory = "#{ENV['HOME']}/dist/stagebox"
    cp "dist/disk", "#{target_directory}/stagebox-#{release_number}.disk"
    cp "dist/iso", "#{target_directory}/stagebox-#{release_number}.iso"
    cp "dist/upgrade.tar", "#{target_directory}/stagebox-#{release_number}.tar"
    create_latest_file "#{target_directory}/latest.yml", release_name, release_number
  end
end

task :buildbot => [:clean, "dist:all", "buildbot:dist"]

namespace :dist do
  desc "Create all distribuable artifacts"
  task :all => [:disk, :iso, :upgrade]

  desc "Create disk image"
  task :disk => "stagebox:dist"

  desc "Create iso image"
  task :iso => "stagebox-demo:dist"

  desc "Create upgrade files"
  task :upgrade do
    rm_rf "dist/upgrade"
    mkdir_p "dist/upgrade"
    ln_s File.expand_path("build/filesystem.squashfs"), "dist/upgrade/filesystem-#{release_name}.squashfs"
    ln_s File.expand_path("build/root/vmlinuz"), "dist/upgrade/vmlinuz-#{release_name}"
    ln_s File.expand_path("build/root/initrd.img"), "dist/upgrade/initrd-#{release_name}.img"
    sh "tar -cf dist/upgrade.tar --dereference -C dist/upgrade ."
  end
end
