class dotfiles {
    vcsrepo { '/home/vdloo/.dotfiles':
      ensure   => latest,
      provider => git,
      source => 'git://github.com/vdloo/dotfiles.git',
      user => 'vdloo',
      owner => 'vdloo',
    }
    include linkdotfiles
}

class linkdotfiles {
    require dotfiles
    file { '/home/vdloo/.bashrc':
	ensure => 'link',
	target => '/home/vdloo/.dotfiles/.bashrc',
	owner => 'vdloo',
    }
    file { '/home/vdloo/.profile':
	ensure => 'link',
	target => '/home/vdloo/.dotfiles/.profile',
	owner => 'vdloo',
    }
    file { '/home/vdloo/.Xdefaults':
	ensure => 'link',
	target => '/home/vdloo/.dotfiles/.Xdefaults',
	owner => 'vdloo',
    }
}
