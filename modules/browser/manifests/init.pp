class browser {
    $browser = $operatingsystem ? {
	/^Debian$/ => 'iceaweasel',
	default => 'firefox',
    }
    package { "$browser":
	ensure => 'installed',
	alias => 'browser',
    }
}
