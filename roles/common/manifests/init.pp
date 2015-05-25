class common {
    require os, default_packages
    include nonroot
    include dotfiles
    include vim	
}

class os {
    case $operatingsystem {
	'Archlinux': 	{ include archlinux }
	'Debian':	{ include debian }
	'Ubuntu':	{ include ubuntu }
    }
}

class default_packages {
    require os
    $vim = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'vim-nox',
	default => 'vim',
    }
    package { "$vim":
	ensure => 'installed',
	alias => 'vim',
    }
    $packages = [
        'curl',
        'git',
        'screen',
        'xclip',
    ]
    package { $packages: 
	ensure => 'installed',
    }
}
