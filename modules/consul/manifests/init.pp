class { '::consul':
  config_hash => {
    'bootstrap_expect' => 1,
    'data_dir'         => '/opt/consul',
    'datacenter'       => 's1',
    'log_level'        => 'INFO',
    'node_name'        => 'common',
    'server'           => true,
  }
}
