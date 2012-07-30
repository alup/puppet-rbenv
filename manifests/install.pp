define rbenv::install($user, $group) {

  # STEP 1
  exec { "rbenv::install::${user}::checkout":
    command => "git clone git://github.com/sstephenson/rbenv.git ${rbenv::paths::dest}",
    user    => $user,
    group   => $group,
    cwd     => $rbenv::paths::root,
    creates => "${rbenv::paths::root}/${rbenv::paths::dest}",
    path    => ['/usr/bin', '/usr/sbin'],
    timeout => 100,
    require => Package['git'],
  }

  # STEP 2
  $rbenvrc = "${rbenv::paths::home}/.rbenvrc"
  $bashrc  = "${rbenv::paths::home}/.bashrc"

  file { "rbenv::install::${user}::rbenvrc":
    path    => $rbenvrc,
    owner   => $user,
    group   => $group,
    content => template('rbenv/dot.rbenvrc.erb'),
  }

  # STEP 3
  exec { "rbenv::install::${user}::add_init_to_bashrc":
    command => "echo 'source ${rbenvrc}' >> ${bashrc}",
    user    => $user,
    group   => $group,
    cwd     => $rbenv::paths::home,
    unless  => "grep -q rbenvrc ${bashrc}",
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
    require => File["rbenv::install::${user}::rbenvrc"],
  }

  file { "rbenv::install::${user}::make_plugins_dir":
    ensure  => directory,
    path    => "${rbenv::paths::root}/${rbenv::paths::dest}/plugins",
    owner   => $user,
    group   => $group,
    require => Exec["rbenv::install::${user}::checkout"],
  }

  # STEP 4
  # Install ruby-build under rbenv plugins directory
  exec { "rbenv::install::${user}::checkout_ruby_build":
    command => 'git clone git://github.com/sstephenson/ruby-build.git',
    user    => $user,
    group   => $group,
    cwd     => "${rbenv::paths::root}/${rbenv::paths::dest}/plugins",
    creates => "${rbenv::paths::root}/${rbenv::paths::dest}/plugins/ruby-build",
    path    => ['/usr/bin', '/usr/sbin'],
    timeout => 100,
    require => File["rbenv::install::${user}::make_plugins_dir"],
  }
}
