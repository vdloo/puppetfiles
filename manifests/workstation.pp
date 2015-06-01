include common
include workstation
include workstation_cron

class workstation_cron {
    cron { "puppet apply":
        command => "/usr/etc/puppetfiles/papply.sh /usr/etc/puppetfiles/manifests/workstation.pp",
        user    => "root",
        hour    => 0,
        minute  => 15
    }
}
