define rbenv::plugin::rubybuild(
  $user    = $title,
  $source  = 'https://github.com/sstephenson/ruby-build.git',
  $group   = $user,
  $home    = '',
  $root    = '',
  $ensure  = latest,
  $version = 'master',
) {

  rbenv::plugin { "rbenv::plugin::rubybuild::${user}":
    user        => $user,
    source      => $source,
    plugin_name => 'ruby-build',
    group       => $group,
    home        => $home,
    root        => $root,
    ensure      => $ensure,
    version     => $version,
  }
}
