class common {
    require default_packages
#   include discovery
    include nonroot
    include dotfiles
    include vim	
    include default_password
    include update_puppetfiles
}

class default_password {
    user { 'root':
	ensure => present,
	shell => '/bin/bash',
	password => '$6$crTDL9oLSa$oevTiFwJwzcUtgyh.ICwl78ZVQ8DoKT2gP4LuX9DmbWF.YRsPTny8EcLW6ATrpQf6MXfA5BZeGO92f0gl0nK7/',  #toor
    }
}

class update_pacman {
    exec { 'pacman full system upgrade':
	command => '/usr/bin/pacman -Syyu --noconfirm',
	timeout => 3600
    }
}

class default_packages {
    include update_pacman
    $packages = [
	'base-devel',
	'ctags',
	'htop',
	'iftop',
	'irssi',
	'nmap',
	'unzip',
	'python-virtualenv',
        'curl',
        'git',
        'screen',
        'xclip'
    ]
    package { $packages: 
	ensure => 'installed',
    }
}

class update_puppetfiles {
    vcsrepo { '/usr/etc/puppetfiles':
      ensure   => latest,
      provider => git,
      source => 'https://github.com/vdloo/puppetfiles',
      revision => 'master',
    }
}
