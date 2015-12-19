class autologin {
  file { '/etc/systemd/system/getty@tty1.service.d':
    ensure => 'directory',
  }

  file { '/etc/systemd/system/getty@tty1.service.d/override.conf':
    ensure => 'present',
    source => 'puppet:///modules/autologin/override.conf',
  }
}
