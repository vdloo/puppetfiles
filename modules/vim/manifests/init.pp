class vim {
    include vimrc
    include vundle
    include zenburn
}

class vimrc {
    file { '/home/vdloo/.vimrc':
	ensure => 'link',
	target => '/home/vdloo/.dotfiles/.vimrc',
	owner => 'vdloo',
    }
}

class createdotvim {
    file { '/home/vdloo/.vim':
	ensure => 'directory',
	owner => 'vdloo',
    }
}

class vundle {
    file { '/home/vdloo/.vim/bundle':
	ensure => 'directory',
	owner => 'vdloo',
    }
    vcsrepo { '/home/vdloo/.vim/bundle/Vundle':
      ensure   => latest,
      provider => git,
      source => 'git://github.com/gmarik/Vundle.vim.git',
      user => 'vdloo',
      owner => 'vdloo',
    }
    require createdotvim
}

class zenburn {
    file { '/home/vdloo/.vim/colors':
	ensure => 'directory',
	owner => 'vdloo',
    }
    wget::fetch { 'download zenburn theme':
        source => 'http://www.vim.org/scripts/download_script.php?src_id=15530',
	destination => '/home/vdloo/.vim/colors/zenburn.vim',
	timeout => 0,
	verbose => false,
	execuser => 'vdloo',
    }
    require [ wget, createdotvim ]
}
