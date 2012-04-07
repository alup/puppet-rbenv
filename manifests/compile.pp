# The following part is optional! It just compiles and installs the chosen
# global ruby version to help on bootstrapping. To achieve this, it uses
# "ruby-build" utility.
define rbenv::compile( $user, $ruby_version ) {

  # Set Timeout to disabled cause we need a lot of time to compile.
  # Use HOME variable and define PATH correctly.
  exec { "install ruby ${ruby_version}":
    command     => "rbenv-install ${ruby_version}",
    timeout     => 0,
    user        => $user,
    group       => $user,
    cwd         => "/home/${user}",
    environment => [ "HOME=/home/${user}" ],
    onlyif      => ['[ -n "$(which rbenv-install)" ]', "[ ! -e /home/${user}/.rbenv/versions/${ruby_version} ]"],
    path        => ["home/${user}/.rbenv/shims", "/home/${user}/.rbenv/bin", "/bin", "/usr/local/bin", "/usr/bin", "/usr/sbin"],
    require     => [Package['curl'], Exec['install ruby-build']],
  }

  exec { "rehash-rbenv":
    command     => "rbenv rehash",
    user        => $user,
    group       => $user,
    cwd         => "/home/${user}",
    environment => [ "HOME=/home/${user}" ],
    onlyif      => '[ -n "$(which rbenv)" ]',
    path        => ["home/${user}/.rbenv/shims", "/home/${user}/.rbenv/bin", "/bin", "/usr/local/bin", "/usr/bin", "/usr/sbin"],
    require     => Exec["install ruby ${ruby_version}"],
  }

  exec { "set-ruby_version":
    command     => "rbenv global ${ruby_version}",
    user        => $user,
    group       => $user,
    cwd         => "/home/${user}",
    environment => [ "HOME=/home/${user}" ],
    onlyif      => '[ -n "$(which rbenv)" ]',
    unless      => "grep ${ruby_version} /home/${user}/.rbenv/version 2>/dev/null",
    path        => ["home/${user}/.rbenv/shims", "/home/${user}/.rbenv/bin", "/bin", "/usr/local/bin", "/usr/bin", "/usr/sbin"],
    require     => [Exec["install ruby ${ruby_version}"], Exec['rehash-rbenv']],
  }
}
