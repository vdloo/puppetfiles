class kodi {
    require refresh_kodi_repo
    require kodi_dependencies
    exec { 'bootstrap kodi':
	command => "/home/${::nonroot_username}/.kodi/bootstrap",
	onlyif => '/usr/bin/test ! -x /usr/local/bin/kodi'
    }
    exec { 'configure kodi':
	command => "/home/${::nonroot_username}/.kodi/configure",
	onlyif => '/usr/bin/test ! -x /usr/local/bin/kodi',
        environment => 'PYTHON_VERSION=2'

    }
    exec { 'build kodi':
	command => "/usr/bin/make -j %{facts.processors.count}",
	cwd => "/home/${::nonroot_username}/.kodi/",
	onlyif => '/usr/bin/test ! -x /usr/local/bin/kodi'
    }
    exec { 'install kodi':
	command => '/usr/bin/make install',
	cwd => "/home/${::nonroot_username}/.kodi/",
	onlyif => '/usr/bin/test ! -x /usr/local/bin/kodi'
    }
}

class clone_kodi_repo {
    vcsrepo { "/home/${::nonroot_username}/.kodi":
      ensure   => latest,
      provider => git,
      source => 'git://github.com/xbmc/xbmc.git',
      user => $::nonroot_username,
      owner => $::nonroot_username,
      revision => 'master',
    }
}

class refresh_kodi_repo {
    require clone_kodi_repo
    exec { 'git clean kodi repo':
	command => '/usr/bin/git clean -f',
	cwd => "/home/${::nonroot_username}/.kodi/"
    }
}

class ffmpeg_dependencies {
    $ffmpeg_deps = [
	'yasm',
    ]
    package { $ffmpeg_deps: 
	ensure => 'installed',
    }
}

class kodi_dependencies {
    require ffmpeg_dependencies
    $kodi_deps = [
	'libxslt',
	'swig',
	'jre7-openjdk',
	'glu',
	'libmariadbclient',
	'libass',
	'dcadec',
	'tinyxml',
	'libcrossguid',
	'taglib',
	'libcdio',
	'libssh',
	'smbclient',
	'gperf',
	'cmake',
	'zip'
    ]
    package { $kodi_deps: 
	ensure => 'installed',
    }
}
