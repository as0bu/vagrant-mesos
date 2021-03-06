
case $::hostname {
  'master01': { $zk_id = 1 }
  'master02': { $zk_id = 2 }
  'master03': { $zk_id = 3 }
  default : { fail("hostname $::hostname not found!")}
}

exec { 'accept oracle license':
  command => 'echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections',
  unless  => 'debconf-show oracle-java9-installer | grep accepted | grep true',
  path    => '/bin:/usr/bin',
}

apt::ppa { 'ppa:webupd8team/java':
  package_manage => true,
  notify         => Exec['apt update'],
}

exec { 'apt update':
  command     => 'apt-get update',
  refreshonly => true,
  path        => '/usr/bin',
}

package { ['ruby', 'ruby-dev', 'oracle-java8-installer']:
  ensure  => 'installed',
  require => Exec['apt update'],
}

class { 'zookeeper':
  servers => ['192.168.11.11', '192.168.11.12', '192.168.11.13'],
  id      => $zk_id,
  require => Exec['apt update'],
}

class { 'mesos':
  repo    => 'mesosphere',
  require => Exec['apt update'],
}

class { 'mesos::cli':
  debug            => false,
  response_timeout => 5,
  zookeeper        => 'zk://192.168.11.11:2181,192.168.11.12:2181,192.168.11.13:2181/mesos',
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

class { 'marathon':
  repo_manage => false,
  zookeeper   => 'zk://192.168.11.11:2181,192.168.11.12:2181,192.168.11.13:2181/marathon',
  master      => 'zk://192.168.11.11:2181,192.168.11.12:2181,192.168.11.13:2181/mesos',
  options     => {
    hostname         => $::hostname,
    event_subscriber => 'http_callback',
  },
  require     => [
    Exec['apt update'],
    Class['mesos::repo'],
    Package['oracle-java8-installer'],
  ],
}

class { 'chronos':
  master              => 'zk://192.168.11.11:2181,192.168.11.12:2181,192.168.11.13:2181/mesos',
  zk_hosts            => '192.168.11.11:2181,192.168.11.12:2181,192.168.11.13:2181',
  conf_dir            => '/etc/chronos/conf',
  http_port           => '4400',
  manage_package_deps => true,
  package_name        => 'chronos',
  service_name        => 'chronos',
  require =>          [
    Exec['apt_update'],
    Package['ruby'],
  ],
}

file { '/etc/profile.d/mesos-master.sh':
  content => 'export MASTER=$(mesos-resolve zk://192.168.11.11:2181,192.168.11.12:2181,192.168.11.13:2181/mesos 2>/dev/null)',
  mode    => '0755',
  owner   => 'root',
  group   => 'root',
}
