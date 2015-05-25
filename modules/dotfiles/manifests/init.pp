class dotfiles {
    require nonroot
    vcsrepo { '/home/vdloo/.dotfiles':
      ensure   => latest,
      provider => git,
      source => 'git://github.com/vdloo/dotfiles.git',
      user => 'vdloo',
      owner => 'vdloo',
    }
}
