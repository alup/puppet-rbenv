define rbenv::plugin(
  $user,
  $source,
  $plugin_name = $title,
  $group       = $user,
  $home        = '',
  $root        = '',
  $timeout     = 100
) {

  $home_path = $home ? { '' => "/home/${user}",       default => $home }
  $root_path = $root ? { '' => "${home_path}/.rbenv", default => $root }
  $destination = "${root_path}/plugins/${plugin_name}"

  if $source !~ /^git:/ {
    fail('Only git plugins are supported')
  }

  exec { "rbenv::plugin::checkout ${user} ${plugin_name}":
    command => "git clone ${source} ${destination}",
    user    => $user,
    group   => $group,
    creates => $destination,
    path    => ['/usr/bin', '/usr/sbin'],
    timeout => $timeout,
    require => File["rbenv::plugins ${user}"],
  }
}
