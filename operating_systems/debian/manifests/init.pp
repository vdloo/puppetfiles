class debian {
    require keyring_packages
    include _debianlike
}
class keyring_packages {
    $packages = [
	'debian-keyring',
	'debian-archive-keyring',
    ]
    package { $packages: 
	ensure => 'installed',
    }
}

