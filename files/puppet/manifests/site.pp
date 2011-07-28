# Defaults

Exec { 
  path => "/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin" 
}

File { 
  checksum => md5, owner => root, group => root
}

import "config.pp"
import "classes/*.pp"

# Use tag boot for resources required at boot (network files, etc ..)

file { "/srv/pige/records":
  ensure => directory,
  owner => pige,
  tag => boot,
  require => Exec["storage-mount"]
}

exec { "storage-init":
  command => "/usr/local/sbin/storage init --label=pige",
  tag => boot
}

exec { "storage-mount":
  command => "mount /srv/pige",
  unless => "mount | grep /srv/pige",
  require => Exec["storage-init"],
  tag => boot
}
