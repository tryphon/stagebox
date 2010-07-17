# Defaults

Exec { 
  path => "/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin" 
}

File { 
  checksum => md5, owner => root, group => root
}

import "config.pp"

# Use tag boot for resources required at boot (network files, etc ..)

file { "/var/etc/network":
  ensure => directory,
  tag => boot
}

file { "/var/etc/network/interfaces":
  content => template("/etc/puppet/templates/interfaces"),
  notify => Exec["restart-networking"],
  tag => boot
}

file { "/etc/network/interfaces":
  ensure => "/var/etc/network/interfaces"
}

exec { "restart-networking": 
  command => "/sbin/ifdown eth0 && /sbin/ifup eth0",
  refreshonly => true
}

file { "/var/etc/darkice/":
  ensure => directory,
  tag => boot
}

file { "/var/etc/darkice/darkice.cfg":
  content => template("/etc/puppet/templates/darkice.cfg"),
  notify => Service[darkice],
  tag => boot
}

service { darkice:
  ensure => running,
  hasrestart => true
}

exec { "copy-var-model":
  creates => "/var/log/dmesg",
  command => "cp -a /var/log.model/* /var/log/",
  tag => boot
}

exec { "amixerconf":
  command => "/usr/local/bin/amixerconf",
  tag => boot
}

file { "/etc/munin/plugins/cpu":
  ensure => "/usr/share/munin/plugins/cpu",
  notify => Service["munin-node"],
  tag => boot
}

file { "/etc/munin/plugins/if_eth0":
  ensure => "/usr/share/munin/plugins/if_",
  notify => Service["munin-node"],
  tag => boot
}

service { "munin-node":
  ensure => running,
  hasrestart => true
}
