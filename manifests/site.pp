import "defaults"
import "classes/*.pp"
import "config"

import "box"

$source_base="/tmp/puppet"

include box
include box::audio

include apache
include apache::dnssd

$darkice_user = "stream"
include users
include darkice::full
include icecast2
include stagecontrol
include pige
