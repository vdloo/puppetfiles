class nonroot {
    user { 
	'vdloo':
	ensure => present,
	shell => '/bin/bash',
	managehome => 'true',
	password => generate('/bin/sh', '-c', "mkpasswd -m sha-512 'toor' | tr -d '\n'"),
    }
}
