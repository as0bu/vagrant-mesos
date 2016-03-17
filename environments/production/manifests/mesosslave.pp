
include docker

exec { 'apt update':
  command     => 'apt-get update && touch /var/lib/apt/vagrant-update',
  creates     => '/var/lib/apt/vagrant-update',
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
  },
  options => {
    'containerizers' => 'docker,mesos',
  },
  require => Class['docker'],
}
