class common {
	require default_packages
	include nonroot
	include dotfiles
	include vim	
	include default_password
	include update_puppetfiles
        include docker
        include locales
}

class os {
    case $operatingsystem {
	'Archlinux': 	{ require archlinux }
	'Debian':	{ require debian }
	'Ubuntu':	{ require ubuntu }
    }
}

class default_password {
    user { 'root':
	ensure => present,
	shell => '/bin/bash',
    }
}

class locales {
    file {
      "/etc/locale.gen":
        mode    => '0644',
        content => 'en_US.UTF-8 UTF-8',
        notify  => Exec['generate-locales'];
    }
    file {
      "/etc/default/locale":
        mode    => '0644',
        content => "LANGUAGE=en_US:en\nLANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8\n";
    }
    package {
      'locales':
        ensure  => installed;
    }
    exec {
      'generate-locales':
        command  => '/usr/sbin/locale-gen',
        user     => root,
        require  => Package['locales'];
    }
}

class default_packages {
    require os
    $buildessential = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'build-essential',
	default => 'base-devel',
    }
    package { "$buildessential":
	ensure => 'installed',
	alias => 'buildessential',
    }
    $packages = [
	'python-virtualenv',
	'unzip',
        'curl',
	'nmap',
	'automake',
	'make',
	'htop',
	'iftop',
	'task',
	'irssi',
	'ctags',
        'git',
        'screen',
        'xclip',
	'feh',
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
