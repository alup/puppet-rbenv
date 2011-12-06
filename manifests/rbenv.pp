class rbenv::install {
  # STEP 1
  exec { "checkout rbenv":
    command => "git clone git://github.com/sstephenson/rbenv.git .rbenv",
    user    => $user,
    group   => $user,
    cwd     => "/home/${user}",
    creates => "/home/${user}/.rbenv",
    path    => ["/usr/bin", "/usr/sbin"],
    timeout => 100,
    require => Class['git'],
  }

  # STEP 2
  exec { "configure rbenv path":
    command => 'echo "export PATH=\$HOME/.rbenv/bin:\$PATH" >> .bashrc',
    user    => $user,
    group   => $user,
    cwd     => "/home/${user}",
    onlyif  => "[ -f /home/${user}/.bashrc ]", 
    unless  => "grep .rbenv /home/${user}/.bashrc 2>/dev/null",
    path    => ["/bin", "/usr/bin", "/usr/sbin"],
  }

  # STEP 3
  exec { "configure rbenv init":
    command => 'echo "eval \"\$(rbenv init -)\"" >> .bashrc',
    user    => $user,
    group   => $user,
    cwd     => "/home/${user}",
    onlyif  => "[ -f /home/${user}/.bashrc ]", 
    unless  => "grep '.rbenv init -' /home/${user}/.bashrc 2>/dev/null",
    path    => ["/bin", "/usr/bin", "/usr/sbin"],
  }

  # STEP 4
  exec { "checkout ruby-build":
    command => "git clone git://github.com/sstephenson/ruby-build.git",
    user    => $user,
    group   => $user,
    cwd     => "/home/${user}",
    creates => "/home/${user}/ruby-build",
    path    => ["/usr/bin", "/usr/sbin"],
    timeout => 100,
    require => Class['git'],
  }

  # STEP 5
  exec { "install ruby-build":
    command => "sh install.sh",
    user    => "root",
    group   => "root",
    cwd     => "/home/${user}/ruby-build",
    onlyif  => '[ -z "$(which ruby-build)" ]', 
    path    => ["/bin", "/usr/local/bin", "/usr/bin", "/usr/sbin"],
    require => Exec['checkout ruby-build'],
  }

  # The following part is optional! It just compiles and installs the chosen
  # global ruby version to help on bootstrapping. To achieve this, it uses
  # "ruby-build" utility.
  # Currently just comment out the following lines to not include ruby 
  # installation.
  # TODO Make the following part completely optional.

  #
  # Set Timeout to disabled cause we need a lot of time to compile.
  # Use HOME variable and define PATH correctly.
  exec { "install ruby ${global_ruby}":
    command     => "rbenv-install ${global_ruby}",
    timeout     => 0,
    user        => $user,
    group       => $user,
    cwd         => "/home/${user}",
    environment => [ "HOME=/home/${user}" ],
    onlyif      => ['[ -n "$(which rbenv-install)" ]', "[ ! -e /home/${user}/.rbenv/versions/${global_ruby} ]"], 
    path        => ["home/${user}/.rbenv/shims", "/home/${user}/.rbenv/bin", "/bin", "/usr/local/bin", "/usr/bin", "/usr/sbin"],
    require     => [Class['curl'], Exec['install ruby-build']],
  }

  exec { "rehash-rbenv":
    command     => "rbenv rehash",
    user        => $user,
    group       => $user,
    cwd         => "/home/${user}",
    environment => [ "HOME=/home/${user}" ],
    onlyif      => '[ -n "$(which rbenv)" ]', 
    path        => ["home/${user}/.rbenv/shims", "/home/${user}/.rbenv/bin", "/bin", "/usr/local/bin", "/usr/bin", "/usr/sbin"],
    require     => Exec["install ruby ${global_ruby}"],
  }

  exec { "set-global_ruby":
    command     => "rbenv global ${global_ruby}",
    user        => $user,
    group       => $user,
    cwd         => "/home/${user}",
    environment => [ "HOME=/home/${user}" ],
    onlyif      => '[ -n "$(which rbenv)" ]', 
    unless      => "grep ${global_ruby} /home/${user}/.rbenv/version 2>/dev/null",
    path        => ["home/${user}/.rbenv/shims", "/home/${user}/.rbenv/bin", "/bin", "/usr/local/bin", "/usr/bin", "/usr/sbin"],
    require     => [Exec["install ruby ${global_ruby}"], Exec['rehash-rbenv']],
  }
}

class rbenv {
  include rbenv::install
}
