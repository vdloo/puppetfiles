class archlinux {
    include update_pacman
}

class download_mirrorlist {
	require wget
	wget::fetch { 'download archlinux mirrorlist':
		source => 'https://www.archlinux.org/mirrorlist/all/',
		destination => "/home/${::nonroot_username}/.mirrorlist",
		timeout => 0,
		verbose => false,
		execuser => $::nonroot_username,
	}
}

class ensure_mirrorlist {
	require download_mirrorlist
	exec { 'uncomment mirrors':
		command => "/usr/bin/sed -i 's/^#Server/Server/' /home/${::nonroot_username}/.mirrorlist",
	}
}

class get_fastest_mirrors {
	require ensure_mirrorlist
	exec { 'rank mirrors':
		command => '/usr/bin/rankmirrors -n 3 /home/${::nonroot_username}/.mirrorlist > /etc/pacman.d/mirrorlist',
	}
}

class update_pacman {
	require get_fastest_mirrors
	exec { 'pacman full system upgrade':
		command => '/usr/bin/pacman -Syyu --noconfirm',
		timeout => 3600
	}
}
