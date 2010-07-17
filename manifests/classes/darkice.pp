class darkice::common {
  file { "/etc/darkice/darkice.cfg":
    ensure => "/var/etc/darkice/darkice.cfg"
  }

  file { "/etc/darkice":
    ensure => directory
  }

  file { "/etc/init.d/darkice":
    source => "$source_base/files/darkice/darkice.init",
    require => File["/etc/default/darkice"],
    mode => 775
  }    
  exec { "update-rc.d darkice defaults":
    require => File["/etc/init.d/darkice"],
    creates => "/etc/rc0.d/K20darkice"
  }

  file { "/etc/default/darkice":
    source => "$source_base/files/darkice/darkice.default",
    require => User[$darkice_user]
  }
}

class darkice::full {
  include darkice::common
  include apt::multimedia
  package { darkice-full: 
    alias => darkice,
    require => Apt::Source[debian-multimedia] 
  }
}

class darkice {
  include darkice::common
  package { darkice: }
}
