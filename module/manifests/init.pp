include users
include init

class users {
    user { 
	'vdloo':
	ensure => present,
	groups => [
	    'audio', 
	    'video', 
	    'netdev',
	],
	shell => '/bin/bash',
	managehome => 'true',
    }
}

class init {
    exec { 'apt-key update':
	command => '/usr/bin/apt-key update'
    }
    exec { 'apt-get update':
	command => '/usr/bin/apt-get update'
    }
    $packages = [
        'curl',
        'git',
        'screen',
        'vim-nox',
        'xclip',
    ]
    package { $packages: 
	ensure => 'installed',
	require => Exec['apt-get update'],
    }
    vcsrepo { '/home/vdloo/.dotfiles':
      ensure   => latest,
      provider => git,
      source => 'git://github.com/vdloo/dotfiles.git',
      user => 'vdloo',
    }
}
