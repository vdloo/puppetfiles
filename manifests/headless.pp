include common
include headless_cron

class headless_cron {
    cron { "puppet apply":
        command => "/usr/etc/puppetfiles/papply.sh /usr/etc/puppetfiles/manifests/headless.pp",
        user    => "root",
        hour    => 0,
        minute  => 15
    }
}
