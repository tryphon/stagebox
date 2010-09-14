import "defaults"
import "classes/*.pp"
import "config"

import "box"

$source_base="/tmp/puppet"

$box_name="stagebox"
include box

include box::audio
include box::storage

$darkice_user = "stream"
include users
include darkice::full
include darkice::safe
include icecast2
include pige
