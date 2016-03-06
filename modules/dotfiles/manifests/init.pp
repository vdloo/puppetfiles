class dotfiles {
    vcsrepo { "/home/${::nonroot_username}/.dotfiles":
	ensure   => latest,
	provider => git,
	source => 'git://github.com/vdloo/dotfiles.git',
	user => $::nonroot_username,
	owner => $::nonroot_username,
    }
    include linkdotfiles
}

class linkdotfiles {
    require dotfiles
    file { "/home/${::nonroot_username}/.bashrc":
	ensure => 'link',
	target => "/home/${::nonroot_username}/.dotfiles/.bashrc",
	owner => $::nonroot_username,
    }
    file { "/home/${::nonroot_username}/.profile":
	ensure => 'link',
	target => "/home/${::nonroot_username}/.dotfiles/.profile",
	owner => $::nonroot_username,
    }
    file { "/home/${::nonroot_username}/.Xdefaults":
	ensure => 'link',
	target => "/home/${::nonroot_username}/.dotfiles/.Xdefaults",
	owner => $::nonroot_username,
    }
    file { "/home/${::nonroot_username}/.xinitrc":
	ensure => 'link',
	target => "/home/${::nonroot_username}/.dotfiles/.xinitrc",
	owner => $::nonroot_username,
    }
}
