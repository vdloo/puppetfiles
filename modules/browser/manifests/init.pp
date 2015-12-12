class browser {
    package { "firefox":
	ensure => 'installed',
	alias => 'browser',
    }
}
