class puppet {
  include cron
  include apt::backport

  package { puppet: 
    ensure => "0.25.4-2~bpo50+1",
    require => Apt::Source::Pin[puppet]
  }
  apt::source::pin { "puppet":
    source => "lenny-backports"
  }

  # Fix support of START=no
  file { "/etc/init.d/puppet":
    source => "$source_base/files/puppet/puppet.init",
    mode => 755
  }

  readonly::mount_tmpfs { "/var/lib/puppet": }

  file { "/etc/init.d/puppet-boot":
    source => "$source_base/files/puppet/puppet-boot.init",
    mode => 755,
    require => File["/usr/local/sbin/launch-puppet"]
  }
  file { "/etc/puppet/manifests":
    ensure => directory,
    recurse => true,
    source => "$source_base/files/puppet/manifests"
  }

  file { "/boot/config.pp":
    source => "$source_base/files/puppet/config.pp"
  }
  file { "/etc/puppet/manifests/config.pp":
    ensure => "/var/etc/puppet/manifests/config.pp"
  }

  file { "/etc/puppet/templates":
    ensure => directory,
    recurse => true,
    source => "$source_base/files/puppet/templates"
  }

  file { "/usr/local/sbin/launch-puppet":
    source => "$source_base/files/puppet/launch-puppet",
    mode => 755
  }
  file { "/usr/local/sbin/save-puppet-config":
    source => "$source_base/files/puppet/save-puppet-config",
    mode => 755
  }

  exec { "update-rc.d-puppet-boot":
    command => "update-rc.d puppet-boot start 38 S . stop 40 0 6 .",
    require => File["/etc/init.d/puppet-boot"],
    creates => "/etc/rcS.d/S38puppet-boot"
  }
  
}
