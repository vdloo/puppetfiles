class htpc {
	include htpc_flag
}

class htpc_flag {
	file {'/usr/etc/machineconf/htpc':
	    mode => '0644',
	    ensure => 'present',
	}
}
