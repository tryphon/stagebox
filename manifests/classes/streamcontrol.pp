class streamcontrol {
  include apache::passenger

  file { "/etc/streamcontrol/database.yml":
    source => "$source_base/files/streamcontrol/database.yml",
    require => Package[streamcontrol]
  }
  file { "/etc/streamcontrol/production.rb":
    source => "$source_base/files/streamcontrol/production.rb",
    require => Package[streamcontrol]
  }
  package { streamcontrol: 
    ensure => latest,
    require => [Apt::Source[tryphon], Package[libapache2-mod-passenger]]
  }

  # Not used for the moment
  readonly::mount_tmpfs { "/var/lib/streamcontrol": }

  # Required for delayed_job.log ...
  file { "/var/log.model/streamcontrol": 
    ensure => directory, 
    owner => www-data
  }

}
