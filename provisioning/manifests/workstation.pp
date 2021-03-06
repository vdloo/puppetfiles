$nonroot_username = hiera('nonroot_username', 'nonroot')
$nonroot_git_email = hiera('nonroot_git_email', 'johndoe@example.com')
$nonroot_git_username = hiera('nonroot_git_username', 'John Doe')

include common
include workstation
include workstation_cron

class workstation_cron {
    cron { "puppet apply":
        command => "/usr/etc/puppetfiles/provisioning/papply.sh /usr/etc/puppetfiles/provisioning/manifests/workstation.pp",
        user    => "root",
        hour    => 0,
        minute  => 15
    }
}
