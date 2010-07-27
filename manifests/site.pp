import "defaults"
import "classes/*.pp"
import "config"

import "box"

$source_base="/tmp/puppet"

$box_name="stagebox"

include release
include users
include network
include network::interfaces

include linux::kernel-2-6-30
include syslog
include smtp
include nano
include ssh

include dbus::readonly
include avahi

include apt
include apt::tryphon
include puppet
include sudo

include alsa::common

$darkice_user = "stream"
include darkice::full
include darkice::safe
include icecast2

include munin::readonly
include munin-node::local

include pige
