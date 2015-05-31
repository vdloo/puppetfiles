class nonroot {
    include createnonrootuser
    include setgitconfig
}

class createnonrootuser {
    user { 
	'vdloo':
	ensure => present,
	shell => '/bin/bash',
	managehome => 'true',
	password => generate('/bin/sh', '-c', "mkpasswd -m sha-512 toor | tr -d '\n'"),
    }
}

class setgitconfig {
    require createnonrootuser
    exec { 'set git user email':
	command => '/bin/su - vdloo -c "/usr/bin/git config --global user.email \'rickvandeloo@gmail.com\'"',
    }
    exec { 'set git user name':
	command => '/bin/su - vdloo -c "/usr/bin/git config --global user.name \'Rick van de Loo\'"',
    }
}
