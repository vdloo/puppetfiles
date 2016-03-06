class workstation {
    include dwm
    include terminal
    include browser
    if $operatingsystem == 'Archlinux' {
      include autologin
    }
}
