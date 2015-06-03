include dwm
class dwm {
    require nonroot
    require refresh_dwm_repo
    require fibonacci
    require gaplessgrid
    require dwmdeps
    require config_h
    exec { 'build dwm':
	command => '/usr/bin/make clean',
	cwd => '/home/vdloo/.dwm/'
    }
    exec { 'install dwm':
	command => '/usr/bin/make install',
	cwd => '/home/vdloo/.dwm/'
    }
}

class clone_dwm_repo {
    vcsrepo { '/home/vdloo/.dwm':
      ensure   => latest,
      provider => git,
      source => 'http://git.suckless.org/dwm',
      user => 'vdloo',
      owner => 'vdloo',
      revision => 'HEAD',
    }
}

class refresh_dwm_repo {
    require clone_dwm_repo
    exec { 'git clean dwm repo':
	command => '/usr/bin/git clean -f',
	cwd => '/home/vdloo/.dwm/'
    }
}

class fibonacci {
    wget::fetch { 'download dwm fibonacci patch':
        source => 'http://dwm.suckless.org/patches/dwm-5.8.2-fibonacci.diff',
	destination => '/home/vdloo/.dwm/fibonacci.diff',
	timeout => 0,
	verbose => false,
	execuser => 'vdloo',
    }
    exec { 'patch dwm with fibonacci':
	command => '/usr/bin/patch < fibonacci.diff -f',
	cwd => '/home/vdloo/.dwm/'
    }
    require [ wget, refresh_dwm_repo ]
}

class gaplessgrid {
    wget::fetch { 'download dwm gapless_grid patch':
        source => 'http://dwm.suckless.org/patches/dwm-6.1-gaplessgrid.diff',
	destination => '/home/vdloo/.dwm/gapless_grid.diff',
	timeout => 0,
	verbose => false,
	execuser => 'vdloo',
    }
    exec { 'patch dwm with gapless_grid':
	command => '/usr/bin/patch < gapless_grid.diff -f',
	cwd => '/home/vdloo/.dwm/'
    }
    require [ wget, refresh_dwm_repo ]
}

class config_h {
    require [ refresh_dwm_repo, fibonacci, gaplessgrid ]
    file { "/home/vdloo/.dwm/config.h":
	ensure => 'link',
	target => "/home/vdloo/.dotfiles/code/configs/dwm/arch-config.h",
    }
}

class dwmdeps {
    $libx11 = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libx11-dev',
	default => 'libX11',
    }
    package { "$libx11":
	ensure => 'installed',
	alias => 'libx11',
    }
    $libxft = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libxft-dev',
	default => 'libxft',
    }
    package { "$libxft":
	ensure => 'installed',
	alias => 'libxft',
    }
    $libxinerama = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libxinerama-dev',
	default => 'libxinerama',
    }
    package { "$libxinerama":
	ensure => 'installed',
	alias => 'libxinerama',
    }
    $xorg = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'xorg',
	default => 'xorg-server',
    }
    package { "$xorg":
	ensure => 'installed',
	alias => 'xorg',
    }
    package { "dmenu":
	ensure => 'installed',
    }
}
