class dwm {
    require nonroot
    require dwmrepo
    require fibonacci
    require gaplessgrid
    exec { 'build dwm':
	command => '/usr/bin/make clean',
	cwd => '/home/vdloo/.dwm/'
    }
    exec { 'install dwm':
	command => '/usr/bin/make install',
	cwd => '/home/vdloo/.dwm/'
    }
}

class dwmrepo {
    vcsrepo { '/home/vdloo/.dwm':
      ensure   => latest,
      provider => git,
      source => 'http://git.suckless.org/dwm',
      user => 'vdloo',
      owner => 'vdloo',
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
    require [ wget, dwmrepo ]
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
    require [ wget, dwmrepo ]
}
