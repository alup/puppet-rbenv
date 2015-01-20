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
      require => Exec["rbenv::checkout ${user}"],
    }
  }

  exec { "rbenv::plugin::checkout ${user} ${plugin_name}":
    command => "git clone ${source} ${destination}",
    user    => $user,
    group   => $group,
    creates => $destination,
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
    timeout => $timeout,
    cwd     => $home_path,
    require => File["rbenv::plugins ${user}"],
  }

  exec { "rbenv::plugin::update ${user} ${plugin_name}":
    command => 'git pull',
    user    => $user,
    group   => $group,
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
    timeout => $timeout,
    cwd     => $destination,
    require => Exec["rbenv::plugin::checkout ${user} ${plugin_name}"],
    onlyif  => 'git remote update; if [ "$(git rev-parse @{0})" = "$(git rev-parse @{u})" ]; then return 0; else return 1; fi ]',
  }

}
