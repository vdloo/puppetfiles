class nonroot {
    include createnonrootuser
    include setgitconfig
    include sudo
    include visudo
}

class createnonrootuser {
    user { 
	'vdloo':
	ensure => present,
	shell => '/bin/bash',
	managehome => 'true',
	password => '$6$crTDL9oLSa$oevTiFwJwzcUtgyh.ICwl78ZVQ8DoKT2gP4LuX9DmbWF.YRsPTny8EcLW6ATrpQf6MXfA5BZeGO92f0gl0nK7/',  #toor
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
    exec { 'set git editor':
	command => '/bin/su - vdloo -c "/usr/bin/git config --global core.editor \'vim\'"',
    }
}

class visudo {
    sudo::conf{ 'vdloo':
        ensure => present,
        content => 'vdloo ALL=(ALL) ALL',
    }
    sudo::conf{ 'vagrant':
        ensure => present,
        content => 'vagrant ALL=(ALL) NOPASSWD: ALL',
    }
    sudo::conf{ 'ssh agent forward':
        ensure => present,
        content => 'Defaults env_keep += "SSH_AUTH_SOCK"',
    }
}
