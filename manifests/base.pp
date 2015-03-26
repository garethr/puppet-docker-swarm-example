class base {
  hiera_include('classes')

  sudo::conf { 'vagrant':
    priority => 30,
    content  => 'vagrant ALL=(ALL) NOPASSWD:ALL',
  }

  file { '/etc/update-motd.d':
    purge => true
  }

  ::docker::image { 'swarm': }

  ::docker::run { 'swarm':
    image   => 'swarm',
    command => "join --addr=${::ipaddress_eth1}:2375 consul://${::ipaddress_eth1}:8500/swarm_nodes"
  }
}


node 'swarm-1' {
  include base

  ::docker::run { 'swarm-manager':
    image   => 'swarm',
    ports   => '3000:2375',
    command => "manage consul://${::ipaddress_eth1}:8500/swarm_nodes",
    require => Docker::Run['swarm'],
  }

}

node default {
  include base

  exec { 'consul join swarm-1':
    path      => '/usr/local/bin/',
    require   => Class['consul'],
    before    => Class['docker'],
    tries     => 10,
    try_sleep => 1,
  }

}
