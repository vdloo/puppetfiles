class nonroot {
    user { 
	'vdloo':
	ensure => present,
	groups => [
	    'audio', 
	    'video', 
	    'netdev',
	],
	shell => '/bin/bash',
	managehome => 'true',
    }
}
