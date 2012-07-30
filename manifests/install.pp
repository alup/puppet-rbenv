define rbenv::install($user, $group, $home_dir) {

  class {'paths': user => $user, home => $home_dir}

  # STEP 1
  exec { "rbenv::install::${user}::checkout":
    command => "git clone git://github.com/sstephenson/rbenv.git ${rbenv::paths::dest}",
    user    => $user,
    group   => $group,
    cwd     => $rbenv::paths::root,
    creates => "${rbenv::paths::root}/${rbenv::paths::dest}",
    path    => ['/usr/bin', '/usr/sbin'],
    timeout => 100,
    require => Package['git-core'],
  }

  # STEP 2
  exec { "rbenv::install::${user}::add_path_to_bashrc":
    command => "echo \"export PATH=${rbenv::paths::root}/${rbenv::paths::dest}/bin:\\\$PATH\" >> .bashrc",
    user    => $user,
    group   => $group,
    cwd     => $rbenv::paths::home,
    onlyif  => "[ -f ${rbenv::paths::home}/.bashrc ]",
    unless  => "grep -q ${rbenv::paths::dest}/bin ${rbenv::paths::home}/.bashrc",
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
  }

  # STEP 3
  exec { "rbenv::install::${user}::add_init_to_bashrc":
    command => 'echo "eval \"\$(rbenv init -)\"" >> .bashrc',
    user    => $user,
    group   => $group,
    cwd     => $rbenv::paths::home,
    onlyif  => "[ -f ${rbenv::paths::home}/.bashrc ]",
    unless  => "grep -q 'rbenv init -' ${rbenv::paths::home}/.bashrc",
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
    require => Exec["rbenv::install::${user}::add_path_to_bashrc"],
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

  # TODO: Support old way of non-plugin installation for ruby-build
  # STEP 5
  #  exec { 'install ruby-build':
  #    command => 'sh install.sh',
  #  user    => 'root',
  #  group   => 'root',
  #  cwd     => "${root_dir}/ruby-build",
  #  onlyif  => '[ -z "$(which ruby-build)" ]',
  #  path    => ['/bin', '/usr/local/bin', '/usr/bin', '/usr/sbin'],
  #  require => Exec["rbenv::install::${user}::checkout_ruby_build"],
  #}
}
