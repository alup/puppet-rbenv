define rbenv::install ( $user ) {
  # STEP 1
  exec { "checkout rbenv":
    command => "git clone git://github.com/sstephenson/rbenv.git .rbenv",
    user    => $user,
    group   => $user,
    cwd     => "/home/${user}",
    creates => "/home/${user}/.rbenv",
    path    => ["/usr/bin", "/usr/sbin"],
    timeout => 100,
    require => Package['git-core'],
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
    unless  => "grep 'rbenv init -' /home/${user}/.bashrc 2>/dev/null",
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
    require => Package['git-core'],
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
}
