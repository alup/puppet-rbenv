# The following part compiles and installs the chosen ruby version,
# using the "ruby-build" rbenv plugin.
#
define rbenv::compile(
  $user,
  $ruby           = $title,
  $group          = $user,
  $home           = '',
  $root           = '',
  $source         = '',
  $global         = false,
  $keep           = false,
  $configure_opts = '--disable-install-doc',
  $bundler        = present,
) {

  # Workaround http://projects.puppetlabs.com/issues/9848
  $home_path = $home ? { '' => "/home/${user}", default => $home }
  $root_path = $root ? { '' => "${home_path}/.rbenv", default => $root }

  $bin         = "${root_path}/bin"
  $shims       = "${root_path}/shims"
  $versions    = "${root_path}/versions"
  $global_path = "${root_path}/version"
  $path        = [ $shims, $bin, '/bin', '/usr/bin' ]

  # Keep flag saves source tree after building.
  # This is required for some gems (e.g. debugger)
  if $keep {
    $keep_flag = '--keep '
  }
  else {
    $keep_flag = ''
  }

  if ! defined( Class['rbenv::dependencies'] ) {
    require rbenv::dependencies
  }

  # If no ruby-build has been specified and the default resource hasn't been
  # parsed
  $custom_or_default = Rbenv::Plugin["rbenv::plugin::rubybuild::${user}"]
  $default           = Rbenv::Plugin::Rubybuild["rbenv::rubybuild::${user}"]
  if ! defined($custom_or_default) and ! defined($default) {
    debug("No ruby-build found for ${user}, going to add the default one")
    rbenv::plugin::rubybuild { "rbenv::rubybuild::${user}":
      user   => $user,
      group  => $group,
      home   => $home,
      root   => $root
    }
  }

  if $source {
    rbenv::definition { "rbenv::definition ${user} ${ruby}":
      user    => $user,
      group   => $group,
      source  => $source,
      ruby    => $ruby,
      home    => $home,
      root    => $root,
      require => Rbenv::Plugin["rbenv::plugin::rubybuild::${user}"],
      before  => Exec["rbenv::compile ${user} ${ruby}"]
    }
  }

  # Set Timeout to disabled cause we need a lot of time to compile.
  # Use HOME variable and define PATH correctly.
  exec { "rbenv::compile ${user} ${ruby}":
    command     => "rbenv install ${keep_flag}${ruby} && touch ${root_path}/.rehash",
    timeout     => 0,
    user        => $user,
    group       => $group,
    cwd         => $home_path,
    environment => [ "HOME=${home_path}", "CONFIGURE_OPTS=${configure_opts}" ],
    creates     => "${versions}/${ruby}",
    path        => $path,
    logoutput   => 'on_failure',
    require     => Rbenv::Plugin["rbenv::plugin::rubybuild::${user}"],
    before      => Exec["rbenv::rehash ${user} ${ruby}"],
  }

  # Install bundler
  #
  rbenv::gem {"rbenv::bundler ${user} ${ruby}":
    ensure => $bundler,
    user   => $user,
    ruby   => $ruby,
    gem    => 'bundler',
    home   => $home_path,
    root   => $root_path,
  }

  exec { "rbenv::rehash ${user} ${ruby}":
    command     => "rbenv rehash && rm -f ${root_path}/.rehash",
    user        => $user,
    group       => $group,
    cwd         => $home_path,
    onlyif      => "[ -e '${root_path}/.rehash' ]",
    environment => [ "HOME=${home_path}" ],
    path        => $path,
    logoutput   => 'on_failure',
    require     => Rbenv::Gem["rbenv::bundler ${user} ${ruby}"],
  }

  # Set default global ruby version for rbenv, if requested
  #
  if $global {
    file { "rbenv::global ${user}":
      path    => $global_path,
      content => "${ruby}\n",
      owner   => $user,
      group   => $group,
      require => Exec["rbenv::compile ${user} ${ruby}"]
    }
  }
}
