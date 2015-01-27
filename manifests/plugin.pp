define rbenv::plugin(
  $user,
  $source,
  $plugin_name = $title,
  $group       = $user,
  $home        = '',
  $root        = '',
  $timeout     = 100
) {

  $home_path   = $home ? { '' => "/home/${user}",       default => $home }
  $root_path   = $root ? { '' => "${home_path}/.rbenv", default => $root }
  $plugins     = "${root_path}/plugins"
  $destination = "${plugins}/${plugin_name}"

  if $source !~ /^(git|https):/ {
    fail('Only git plugins are supported')
  }

  if ! defined(File["rbenv::plugins ${user}"]) {
    file { "rbenv::plugins ${user}":
      ensure  => directory,
      path    => $plugins,
      owner   => $user,
      group   => $group,
      require => Vcsrepo[$root_path],
    }
  }

  vcsrepo { $destination:
    ensure  => latest,
    source  => $source,
    owner   => $user,
    group   => $group,
    require => File["rbenv::plugins ${user}"],
  }
}
