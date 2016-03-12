class kodi {
    require refresh_kodi_repo
    require kodi_dependencies
    exec { 'bootstrap kodi':
	command => "/home/${::nonroot_username}/.kodi/bootstrap",
	cwd => "/home/${::nonroot_username}/.kodi/",
	onlyif => '/usr/bin/test ! -x /usr/local/bin/kodi'
    }
    exec { 'configure kodi':
	command => "/home/${::nonroot_username}/.kodi/configure",
	cwd => "/home/${::nonroot_username}/.kodi/",
	onlyif => '/usr/bin/test ! -x /usr/local/bin/kodi',
        environment => 'PYTHON_VERSION=2',
	timeout     => 600
    }
    exec { 'build kodi':
	command => "/usr/bin/make -j $processorcount",
	cwd => "/home/${::nonroot_username}/.kodi/",
	onlyif => '/usr/bin/test ! -x /usr/local/bin/kodi',
	timeout     => 600
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

class bootstrap_depends {
    require refresh_kodi_repo
    exec { 'bootstrap depends':
	command => "/home/${::nonroot_username}/.kodi/tools/depends/bootstrap",
	cwd => "/home/${::nonroot_username}/.kodi/tools/depends",
        environment => 'PREFIX=/usr/local'
    }
}

class configure_depends {
    require refresh_kodi_repo
    require bootstrap_depends
    exec { 'configure depends':
	command => "/home/${::nonroot_username}/.kodi/tools/depends/configure --prefix=/usr/local",
	cwd => "/home/${::nonroot_username}/.kodi/tools/depends",
        environment => 'PREFIX=/usr/local',
	timeout     => 600
    }
}

class install_crossguid {
    package { "libcrossguid":
	ensure => 'installed',
    }
}

class build_crossguid {
    require refresh_kodi_repo
    require bootstrap_depends
    require configure_depends
    exec { 'build crossguid':
	command => "/usr/bin/make -C target/crossguid",
	cwd => "/home/${::nonroot_username}/.kodi/tools/depends",
        environment => 'PREFIX=/usr/local',
	timeout     => 600
    }
}

class install_dcadec {
    package { "dcadec":
	ensure => 'installed',
    }
}

class build_dcadec {
    require refresh_kodi_repo
    require bootstrap_depends
    require configure_depends
    exec { 'build dcadec':
	command => "/usr/bin/make -C target/libdcadec",
	cwd => "/home/${::nonroot_username}/.kodi/tools/depends",
        environment => 'PREFIX=/usr/local',
	timeout     => 600
    }
}

class install_taglib {
    package { "taglib":
	ensure => 'installed',
    }
}

class build_taglib {
    require refresh_kodi_repo
    require bootstrap_depends
    require configure_depends
    exec { 'build taglib':
	command => "/usr/bin/make -C target/taglib/",
	cwd => "/home/${::nonroot_username}/.kodi/tools/depends",
        environment => 'PREFIX=/usr/local',
	timeout     => 600
    }
}


class kodi_dependencies {
    require ffmpeg_dependencies
    $libxslt = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libxslt-dev',
	default => 'libxslt',
    }
    package { "$libxslt":
	ensure => 'installed',
    }
    $openjdk = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'openjdk-7-jdk',
	default => 'jre7-openjdk',
    }
    package { "$openjdk":
	ensure => 'installed',
    }
    $glu = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libglu-dev',
	default => 'glu',
    }
    package { "$glu":
	ensure => 'installed',
    }
    $mariadbclient = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'mariadb-client',
	default => 'libmariadbclient',
    }
    package { "$mariadbclient":
	ensure => 'installed',
    }
    $libass = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libass-dev',
	default => 'libass',
    }
    package { "$libass":
	ensure => 'installed',
    }
    $tinyxml = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libtinyxml-dev',
	default => 'tinyxml',
    }
    package { "$tinyxml":
	ensure => 'installed',
    }
    $libcdio = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libcdio-dev',
	default => 'libcdio',
    }
    package { "$libcdio":
	ensure => 'installed',
    }
    $libssh = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'libssh-dev',
	default => 'libssh',
    }
    package { "$libssh":
	ensure => 'installed',
    }
    $libuuid = $operatingsystem ? {
	/^(Debian|Ubuntu)$/ => 'uuid-dev',
	default => 'util-linux',
    }
    package { "$libuuid":
	ensure => 'installed',
    }
    case $operatingsystem {
	'Archlinux': 	{ include install_crossguid }
	'Debian':	{ include build_crossguid }
	'Ubuntu':	{ include build_crossguid }
    }
    case $operatingsystem {
	'Archlinux': 	{ include install_dcadec }
	'Debian':	{ include build_dcadec }
	'Ubuntu':	{ include build_dcadec }
    }
    case $operatingsystem {
	'Archlinux': 	{ include install_taglib }
	'Debian':	{ include build_taglib }
	'Ubuntu':	{ include build_taglib }
    }
    $kodi_deps = [
	'swig',
	'smbclient',
	'gperf',
	'cmake',
	'zip'
    ]
    package { $kodi_deps: 
	ensure => 'installed',
    }
}
