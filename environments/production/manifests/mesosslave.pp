class{'mesos':
  repo => 'mesosphere',
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
