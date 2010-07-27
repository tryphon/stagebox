class icecast2 {

  package { icecast2: }

  file { "/etc/icecast2/icecast.xml":
    source => "$source_base/files/icecast2/icecast.xml",
    require => Package[icecast2],
    owner => icecast2,
    group => adm,
    mode => 640
  }

  file { "/etc/default/icecast2":
    source => "$source_base/files/icecast2/icecast2.default",
    require => Package[icecast2]
  }

  file { "/var/log.model/icecast2": 
    ensure => directory, 
    owner => icecast2,
    require => Package[icecast2]
  }

}
