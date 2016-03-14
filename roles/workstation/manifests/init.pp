require common

class workstation {
	include dwm
	include terminal
	include browser
	if $operatingsystem == 'Archlinux' {
	    include autologin
	}
	include workstation_flag
}

class workstation_flag {
	file {'/usr/etc/machineconf/workstation':
	    mode => '0644',
	    ensure => 'present',
	}
}
