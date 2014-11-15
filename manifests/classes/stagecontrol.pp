class stagecontrol {
  include apache::passenger
  include apache::xsendfile
  include ruby::bundler

  include apt::tryphon::dev

  # Not used for the moment
  readonly::mount_tmpfs { '/var/lib/stagecontrol': }

  file { '/etc/stagecontrol/database.yml':
    source => 'puppet:///files/stagecontrol/database.yml',
    require => Package['stagecontrol']
  }
  file { '/etc/stagecontrol/production.rb':
    source => 'puppet:///files/stagecontrol/production.rb',
    require => Package['stagecontrol']
  }
  package { stagecontrol:
    ensure => '0.7-1+build26',
    require => [Apt::Source['tryphon-dev'], Package['libapache2-mod-passenger']]
  }

  # Required for delayed_job.log ...
  file { '/var/log.model/stagecontrol':
    ensure => directory,
    owner => www-data
  }

  file { '/etc/cron.hourly/clean-tempfiles':
    mode => 755,
    content => '#!/bin/sh\nfind /srv/pige/tmp -mmin +60 -type f | xargs -r rm',
    require => Package[cron]
  }

  file { '/etc/puppet/manifests/classes/stagecontrol.pp':
    source => 'puppet:///files/stagecontrol/manifest.pp'
  }
}
