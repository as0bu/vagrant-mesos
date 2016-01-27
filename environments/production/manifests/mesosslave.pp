class {'apt':
  proxy   => {
    host => '192.168.11.11',
    port => '3142',
  },
  notify  => Exec['apt update'],
}

exec { 'apt update':
  command     => 'apt-get update',
  refreshonly => true,
  path        => '/usr/bin',
}

class{'mesos':
  repo    => 'mesosphere',
  require => Exec['apt update'],
}

class{'mesos::slave':
  zookeeper  => 'zk://192.168.11.11:2181,192.168.11.12:2181,192.168.11.13:2181/mesos',
  listen_address => $::ipaddress_eth1,
  attributes => {
    'env' => 'production',
  },
  resources => {
    'ports' => '[2000-65535]'
  }
}
