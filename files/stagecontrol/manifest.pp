file { '/srv/pige/db':
  ensure => directory,
  owner => www-data,
  tag => boot,
  require => Exec['storage-mount-pige']
}

exec { 'pige-create-db':
  creates => '/srv/pige/db/production.sqlite3',
  command => 'install --owner=www-data --group=www-data --mode=644 /usr/share/stagecontrol/db/production.sqlite3 /srv/pige/db/production.sqlite3',
  require => File['/srv/pige/db'],
  tag => boot
}

exec { 'pige-migrate-db':
  command => '/usr/share/stagecontrol/script/migrate',
  cwd => '/usr/share/stagecontrol',
  user => 'www-data',
  require => Exec['pige-create-db'],
  tag => boot
}
