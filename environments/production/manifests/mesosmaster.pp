case $::hostname {
  'master01': { $zk_id = 1 }
  'master02': { $zk_id = 2 }
  'master03': { $zk_id = 3 }
  default : { fail("hostname $::hostname not found!")}
}

class { 'zookeeper':
  servers => ['192.168.11.11', '192.168.11.12', '192.168.11.13'],
  id      => $zk_id,
}

class { 'mesos':
  repo => 'mesosphere',
}

class { 'mesos::master':
  zookeeper      => 'zk://192.168.11.11:2181,192.168.11.12:2181,192.168.11.13:2181/mesos',
  work_dir       => '/var/lib/mesos',
  options        => {
    quorum   => 2
  },
  listen_address => $::ipaddress_eth1,
  require => Class['zookeeper']
}
