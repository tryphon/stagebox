class stagecontrol {
  include apt::tryphon
  include apache::passenger

  # Not used for the moment
  readonly::mount_tmpfs { "/var/lib/stagecontrol": }

  file { "/etc/stagecontrol/database.yml":
    source => "puppet:///files/stagecontrol/database.yml",
    require => Package[stagecontrol]
  }
  file { "/etc/stagecontrol/production.rb":
    source => "puppet:///files/stagecontrol/production.rb",
    require => Package[stagecontrol]
  }
  package { stagecontrol: 
    ensure => "latest",
    require => [Apt::Source[tryphon], Package[libapache2-mod-passenger]]
  }

  # Required for delayed_job.log ...
  file { "/var/log.model/stagecontrol": 
    ensure => directory, 
    owner => www-data
  }
}
