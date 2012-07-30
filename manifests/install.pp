define rbenv::install(
  $user  = $title,
  $group = $user,
  $home  = "/home/$user",
  $root  = "${home}/.rbenv",
) {

  $rbenvrc = "${home}/.rbenvrc"
  $bashrc  = "${home}/.bashrc"
  $plugins = "${root}/plugins"

  if ! defined( Class['rbenv-dependencies'] ) {
    require rbenv::dependencies
  }

  exec { "rbenv::checkout ${user}":
    command => "git clone git://github.com/sstephenson/rbenv.git ${root}",
    user    => $user,
    group   => $group,
    creates => $root,
    path    => ['/usr/bin', '/usr/sbin'],
    timeout => 100,
    require => Package['git'],
  }

  file { "rbenv::rbenvrc ${user}":
    path    => $rbenvrc,
    owner   => $user,
    group   => $group,
    content => template('rbenv/dot.rbenvrc.erb'),
  }

  exec { "rbenv::bashrc ${user}":
    command => "echo 'source ${rbenvrc}' >> ${bashrc}",
    user    => $user,
    group   => $group,
    unless  => "grep -q rbenvrc ${bashrc}",
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
    require => File["rbenv::rbenvrc ${user}"],
  }

  file { "rbenv::plugins ${user}":
    ensure  => directory,
    path    => $plugins,
    owner   => $user,
    group   => $group,
    require => Exec["rbenv::checkout ${user}"],
  }

  exec { "rbenv::ruby-build ${user}":
    command => "git clone git://github.com/sstephenson/ruby-build.git ${plugins}",
    user    => $user,
    group   => $group,
    creates => "${plugins}/ruby-build",
    path    => ['/usr/bin', '/usr/sbin'],
    timeout => 100,
    require => File["rbenv::plugins ${user}"],
  }

}
