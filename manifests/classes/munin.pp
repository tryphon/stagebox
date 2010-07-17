class munin-node::local inherits munin-node {
  # plugins are defined by puppet on boot
  readonly::mount_tmpfs { "/etc/munin/plugins": }
  # required by ping_ plugin
  package { iputils-ping: }
}
