class pige {
  $records_status_on_silent = "warning"

  # from Puppet-Box
  class { 'pige::base':
    web_application => 'stagecontrol',
  }

  file { "/usr/local/bin/remove-silent-file":
    mode => 755,
    source => "puppet:///files/pige/remove-silent-file"
  }

  include pige::storage::rsyncd
}

class pige::storage::rsyncd {
  include rsync

  file { "/etc/rsyncd.conf":
    source => "$source_base/files/rsync/rsyncd.conf"
  }

  file { "/etc/default/rsync":
    source => "$source_base/files/rsync/rsync.default"
  }
}
