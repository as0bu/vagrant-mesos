class {'mesos':
  repo => 'mesosphere',
}

class{'mesos::master':
  zookeeper  => 'zk://192.168.11.1:2181,192.168.11.2:2181,192.168.11.3:2181/mesos',
  work_dir   => '/var/lib/mesos',
  options    => {
    quorum   => 2
  },
}
