class kodi {
    require refresh_kodi_repo
    require kodi_dependencies
    exec { 'bootstrap kodi':
	command => "/home/${::nonroot_username}/.kodi/bootstrap",
	onlyif => 'test ! -x /usr/local/bin/kodi'
    }
    exec { 'configure kodi':
	command => "/home/${::nonroot_username}/.kodi/configure",
	onlyif => 'test ! -x /usr/local/bin/kodi'

    }
    exec { 'build kodi':
	command => 'make -j %{facts.processors.count}',
	cwd => "/home/${::nonroot_username}/.kodi/",
	onlyif => 'test ! -x /usr/local/bin/kodi'
    }
    exec { 'install kodi':
	command => 'make install',
	cwd => "/home/${::nonroot_username}/.kodi/",
	onlyif => 'test ! -x /usr/local/bin/kodi'
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
	'mysqlclient',
	'libass',
	'dcadec',
	'tinyxml'
	'libcrossguid',
	'taglib'
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
