class _debianlike {
    include update_apt
}
class update_apt {
    exec { 'apt-key update':
	command => '/usr/bin/apt-key update'
    }
    exec { 'apt-get update':
	command => '/usr/bin/apt-get update'
    }
}

