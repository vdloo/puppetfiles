include users
include default_packages
include dotfiles

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

class update_apt {
    $packages = [
	'debian-keyring',
	'debian-archive-keyring',
    ]
    package { $packages: 
	ensure => 'installed',
    }
    exec { 'apt-key update':
	command => '/usr/bin/apt-key update'
    }
    exec { 'apt-get update':
	command => '/usr/bin/apt-get update'
    }
}

class default_packages {
    require update_apt
    $packages = [
        'curl',
        'git',
        'screen',
        'vim-nox',
        'xclip',
    ]
    package { $packages: 
	ensure => 'installed',
    }
}

class dotfiles {
    require users
    vcsrepo { '/home/vdloo/.dotfiles':
      ensure   => latest,
      provider => git,
      source => 'git://github.com/vdloo/dotfiles.git',
      user => 'vdloo',
      owner => 'vdloo',
    }
}
