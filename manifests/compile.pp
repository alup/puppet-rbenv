# The following part compiles and installs the chosen ruby version,
# using the "ruby-build" rbenv plugin.
#
define rbenv::compile(
  $user,
  $ruby        = $title,
  $group       = $user,
  $home        = "/home/${user}",
  $root        = "${home}/.rbenv",
  $source      = '',
  $set_default = false,
) {

  $bin       = "${root}/bin"
  $shims     = "${root}/shims"
  $versions  = "${root}/versions"
  $global    = "${root}/version"
  $path      = [ $shims, $bin, '/bin', '/usr/bin' ]

  if ! defined( Class['rbenv-dependencies'] ) {
    require rbenv::dependencies
  }

  if $source {
    rbenv::definition { "rbenv::definition ${user} ${ruby}":
      user    => $user,
      group   => $group,
      source  => $source,
      ruby    => $ruby,
      home    => $home,
      root    => $root,
      require => Exec["rbenv::ruby-build ${user}"],
      before  => Exec["rbenv::compile ${user}"]
    }
  }

  # Set Timeout to disabled cause we need a lot of time to compile.
  # Use HOME variable and define PATH correctly.
  exec { "rbenv::compile ${user} ${ruby}":
    command     => "rbenv install ${ruby}; touch ${root}/.rehash",
    timeout     => 0,
    user        => $user,
    group       => $group,
    cwd         => $home,
    environment => [ "HOME=${home}" ],
    creates     => "${versions}/${ruby}",
    path        => $path,
    require     => Exec["rbenv::ruby-build ${user}"],
    before      => Exec["rbenv::rehash ${user}"],
  }

  if ! defined( Exec["rbenv::rehash ${user}"] ) {
    exec { "rbenv::rehash ${user}":
      command     => "rbenv rehash; rm -f ${root}/.rehash",
      user        => $user,
      group       => $group,
      cwd         => $home,
      onlyif      => "[ -e '${root}/.rehash' ]",
      environment => [ "HOME=${home}" ],
      path        => $path,
    }
  }

  # Install bundler
  #
  gem {"rbenv::bundler ${user} ${ruby}":
    gem    => 'bundler',
    ensure => present,
    user   => $user,
    ruby   => $ruby,
    home   => $home,
    root   => $root,
  }

  # Set default global ruby version for rbenv, if requested
  #
  if $set_default {
    file { "rbenv::global ${user}":
      path    => $global,
      content => "$ruby\n",
      owner   => $user,
      group   => $group,
    }
  }

}
