# The following part is optional! It just compiles and installs the chosen
# global ruby version to help on bootstrapping. To achieve this, it uses
# "ruby-build" utility.
define rbenv::compile($user, $group, $ruby_version) {

  $path = [
    $rbenv::paths::shims, $rbenv::paths::bin,
    '/bin', '/usr/local/bin', '/usr/bin', '/usr/sbin'
  ]

  # Set Timeout to disabled cause we need a lot of time to compile.
  # Use HOME variable and define PATH correctly.
  exec { "install ruby ${user} ${ruby_version}":
    command     => "rbenv install ${ruby_version}",
    timeout     => 0,
    user        => $user,
    group       => $group,
    cwd         => $rbenv::paths::home,
    environment => [ "HOME=${rbenv::paths::home}" ],
    creates     => "${rbenv::paths::versions}/${ruby_version}",
    onlyif      => "[ -e '${rbenv}' ]",
    path        => $path,
    require     => [Class['rbenv::dependencies'], Exec["rbenv::install::${user}::checkout_ruby_build"]],
  }

  exec { "rehash-rbenv $user":
    command     => 'rbenv rehash',
    user        => $user,
    group       => $group,
    cwd         => $rbenv::paths::home,
    environment => [ "HOME=${rbenv::paths::home}" ],
    creates     => "${rbenv::paths::shims}/ruby",
    onlyif      => "[ -e '${rbenv}' ]",
    path        => $path,
    require     => Exec["install ruby ${user} ${ruby_version}"],
  }

  file { "set-ruby_version $user":
    path    => $rbenv::paths::global_version,
    content => "$ruby_version\n",
    owner   => $user,
    group   => $group,
  }

}
