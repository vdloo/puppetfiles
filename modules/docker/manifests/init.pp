class docker {
    require os
    # only install docker on Archlinux
    # machines for because the Debian /
    # Ubuntu repo versions are outdated.
    if $operatingsystem == 'Archlinux' {
        package { "docker":
            ensure => 'installed',
            alias => 'docker'
        }
        service { "docker": 
            enabled => true,
            ensure => running
        }
    }
}
