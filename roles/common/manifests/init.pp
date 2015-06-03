class common {
    require os, default_packages
    include nonroot
    include dotfiles
    include vim	
    include default_password
}

class os {
    case $operatingsystem {
	'Archlinux': 	{ include archlinux }
	'Debian':	{ include debian }
	'Ubuntu':	{ include ubuntu }
    }
}

class default_password {
    user { 'root':
	ensure => present,
	shell => '/bin/bash',
	password => '$6$crTDL9oLSa$oevTiFwJwzcUtgyh.ICwl78ZVQ8DoKT2gP4LuX9DmbWF.YRsPTny8EcLW6ATrpQf6MXfA5BZeGO92f0gl0nK7/',  #toor
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
