class nonroot {
    include createnonrootuser
    include setgitconfig
    include sudo
    include visudo
}

class createnonrootuser {
    user { 
        $::nonroot_username:
        ensure => present,
        shell => '/bin/bash',
        managehome => 'true',
    }
    ssh_authorized_key { 'insecure': 
        user => "${::nonroot_username}", 
        type => 'rsa', 
        key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC67IvPysSnCtOfzKmu33jDlbyFC6cLR3OwMkUWzzsYVrjGZWzaJI+JORHg2hI7SQG7v0YK1oHMnUDE3WL4Dc8JoFY0mOXxtSpbvrQrjc+mAzMPy5ITP5mGdFr/mXE8z5lLWlWX5/oNLZN6EVUro6UYjiVDarDQiR1Y2UfeoxkIXMCydQ2Yls8wBZc0uLrkEl3CPwImUsIfsvJvGrx+TGPUNT+cONbX3X1t8OHT8t40Xx+vQcV4lmDTg00sprrPvn57RniB9B3shbDfwBxTAWXOR9C79f4xURjUrzI5FQI5sMfF7Fhchvr6k4fx7TfDdhbqUG7iOBTAyE1fiXKkp7NX',
     }
}

class setgitconfig {
    require createnonrootuser
    # if the nonroot_git_* entries are not defined in hiera the use email and name will default to 
    exec { 'set git user email':
        command => "/bin/su - ${::nonroot_username} -c \"/usr/bin/git config --global user.email '${::nonroot_git_email}'\"",
    }
    exec { 'set git user name':
        command => "/bin/su - ${::nonroot_username} -c \"/usr/bin/git config --global user.name '${::nonroot_git_username}'\"",
    }
    exec { 'set git editor':
        command => "/bin/su - ${::nonroot_username} -c \"/usr/bin/git config --global core.editor 'vim'\"",
    }
}

class visudo {
    sudo::conf{ $::nonroot_username:
        ensure => present,
        content => hiera('nonroot_sudoers_entry', "${::nonroot_username} ALL=(ALL) ALL"),
    }
    sudo::conf{ 'vagrant':
        ensure => present,
        content => 'vagrant ALL=(ALL) NOPASSWD: ALL',
    }
    sudo::conf{ 'android':
        ensure => present,
        content => 'android ALL=(ALL) NOPASSWD: ALL',
    }
}
