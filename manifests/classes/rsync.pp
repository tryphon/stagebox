class rsync {
  package { rsync: }
}

class rsync::satellite {

  file { "/etc/rsyncd.conf":
    source => "$puppet_files/rsync/rsyncd.conf.satellite"
  }

  file { "/etc/default/rsync":
    source => "$puppet_files/rsync/rsync.default"
  }

  service { rsync: 
    ensure => running,
    require => Package[rsync],
    subscribe => [File["/etc/rsyncd.conf"], File["/etc/default/rsync"]],
    hasrestart => true
  }

}
