define rbenv::install ( $user ) {

  # Assign different values for shared install
  case $user {
    'root':  {
      $home_dir =  "/root"
      $root_dir = "/usr/local"
      $install_dir = "rbenv"
    }
    default: {
      $home_dir = "/home/${user}"
      $root_dir = "/home/${user}"
      $install_dir = ".rbenv"
    }
  }

  # STEP 1
  exec { "checkout rbenv $user":
    command => "git clone git://github.com/sstephenson/rbenv.git ${install_dir}",
    user    => $user,
    group   => $user,
    cwd     => $root_dir,
    creates => "${root_dir}/${install_dir}",
    path    => ["/usr/bin", "/usr/sbin"],
    timeout => 100,
    require => Package['git-core'],
  }

  # STEP 2
  exec { "configure rbenv path $user":
    command => "echo \"export PATH=${root_dir}/${install_dir}/bin:\$PATH\" >> .bashrc",
    user    => $user,
    group   => $user,
    cwd     => $home_dir,
    onlyif  => "[ -f ${home_dir}/.bashrc ]",
    unless  => "grep ${install_dir}/bin ${home_dir}/.bashrc 2>/dev/null",
    path    => ["/bin", "/usr/bin", "/usr/sbin"],
  }

  # STEP 3
  exec { "configure rbenv init $user":
    command => 'echo "eval \"\$(rbenv init -)\"" >> .bashrc',
    user    => $user,
    group   => $user,
    cwd     => $home_dir,
    onlyif  => "[ -f ${home_dir}/.bashrc ]",
    unless  => "grep 'rbenv init -' ${home_dir}/.bashrc 2>/dev/null",
    path    => ["/bin", "/usr/bin", "/usr/sbin"],
  }

  file { "mkdir plugins $user":
    ensure  => directory,
    path    => "${root_dir}/${install_dir}/plugins",
    owner   => $user,
    group   => $user,
    require => Exec["checkout rbenv $user"],
  }

  # STEP 4
  # Install ruby-build under rbenv plugins directory
  exec { "checkout ruby-build plugin $user":
    command => "git clone git://github.com/sstephenson/ruby-build.git",
    user    => $user,
    group   => $user,
    cwd     => "${root_dir}/${install_dir}/plugins",
    creates => "${root_dir}/${install_dir}/plugins/ruby-build",
    path    => ["/usr/bin", "/usr/sbin"],
    timeout => 100,
    require => File["mkdir plugins $user"],
  }

  # TODO: Support old way of non-plugin installation for ruby-build
  # STEP 5
  #  exec { "install ruby-build":
  #    command => "sh install.sh",
  #  user    => "root",
  #  group   => "root",
  #  cwd     => "${root_dir}/ruby-build",
  #  onlyif  => '[ -z "$(which ruby-build)" ]',
  #  path    => ["/bin", "/usr/local/bin", "/usr/bin", "/usr/sbin"],
  #  require => Exec['checkout ruby-build'],
  #}
}
