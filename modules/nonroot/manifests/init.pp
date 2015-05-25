class nonroot {
    user { 
	'vdloo':
	ensure => present,
	shell => '/bin/bash',
	managehome => 'true',
    }
}
