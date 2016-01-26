class{'mesos':
  repo => 'mesosphere',
}

class{'mesos::slave':
  zookeeper  => 'zk://192.168.1.1:2181,192.168.1.2:2181,192.168.1.3:2181/mesos',
  listen_address => $::ipaddress_eth1,
  attributes => {
    'env' => 'production',
  },
  resources => {
    'ports' => '[2000-65535]'
  }
}
