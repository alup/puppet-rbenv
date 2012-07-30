# The following part is optional! It just compiles and installs the chosen
# global ruby version to help on bootstrapping. To achieve this, it uses
# "ruby-build" utility.
define rbenv::compile( $user, $group, $home_dir, $ruby_version ) {

  # Set Timeout to disabled cause we need a lot of time to compile.
  # Use HOME variable and define PATH correctly.
  exec { "install ruby ${user} ${ruby_version}":
    command     => "rbenv install ${ruby_version}",
    timeout     => 0,
    user        => $user,
    group       => $group,
    cwd         => $rbenv::paths::home,
    environment => [ "HOME=${rbenv::paths::home}" ],
    onlyif      => ['[ -n "$(which rbenv)" ]', "[ ! -e ${rbenv::paths::root}/${rbenv::paths::dest}/versions/${ruby_version} ]"],
    path        => ["${rbenv::paths::root}/${rbenv::paths::dest}/shims",
                    "${rbenv::paths::root}/${rbenv::paths::dest}/bin",
                    '/bin', '/usr/local/bin', '/usr/bin', '/usr/sbin'],
    require     => [Class['rbenv::dependencies'], Exec["rbenv::install::${user}::checkout_ruby_build"]],
  }

  exec { "rehash-rbenv $user":
    command     => 'rbenv rehash',
    user        => $user,
    group       => $group,
    cwd         => $rbenv::paths::home,
    environment => [ "HOME=${rbenv::paths::home}" ],
    onlyif      => '[ -n "$(which rbenv)" ]',
    path        => ["${rbenv::paths::root}/${rbenv::paths::dest}/shims",
                    "${rbenv::paths::root}/${rbenv::paths::dest}/bin",
                    '/bin', '/usr/local/bin', '/usr/bin', '/usr/sbin'],
    require     => Exec["install ruby ${user} ${ruby_version}"],
  }

  exec { "set-ruby_version $user":
    command     => "rbenv global ${ruby_version}",
    user        => $user,
    group       => $group,
    cwd         => $rbenv::paths::home,
    environment => [ "HOME=${rbenv::paths::home}" ],
    onlyif      => '[ -n "$(which rbenv)" ]',
    unless      => "grep -q ${ruby_version} ${rbenv::paths::root}/${rbenv::paths::dest}/version",
    path        => ["${rbenv::paths::root}/${rbenv::paths::dest}/shims",
                    "${rbenv::paths::root}/${rbenv::paths::dest}/bin",
                    '/bin', '/usr/local/bin', '/usr/bin', '/usr/sbin'],
    require     => [Exec["install ruby ${user} ${ruby_version}"], Exec["rehash-rbenv $user"]],
  }
}
