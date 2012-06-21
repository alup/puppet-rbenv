# The following part is optional! It just compiles and installs the chosen
# global ruby version to help on bootstrapping. To achieve this, it uses
# "ruby-build" utility.
define rbenv::compile( $user, $group, $home_dir, $ruby_version ) {

  # FIXME : move this to top level to be DRY
  # Assign different values for shared install
  case $user {
    'root':  {
      $home_dir =  '/root'
      $root_dir = '/usr/local'
      $install_dir = 'rbenv'
    }
    default: {
      $root_dir = $home_dir
      $install_dir = '.rbenv'
    }
  }


  # Set Timeout to disabled cause we need a lot of time to compile.
  # Use HOME variable and define PATH correctly.
  exec { "install ruby ${user} ${ruby_version}":
    command     => "rbenv install ${ruby_version}",
    timeout     => 0,
    user        => $user,
    group       => $group,
    cwd         => $home_dir,
    environment => [ "HOME=${home_dir}" ],
    onlyif      => ['[ -n "$(which rbenv)" ]', "[ ! -e ${root_dir}/${install_dir}/versions/${ruby_version} ]"],
    path        => ["${root_dir}/${install_dir}/shims", "${root_dir}/${install_dir}/bin", '/bin', '/usr/local/bin', '/usr/bin', '/usr/sbin'],
    require     => [Class['rbenv::dependencies'], Exec["rbenv::install::${user}::checkout_ruby_build"]],
  }

  exec { "rehash-rbenv $user":
    command     => 'rbenv rehash',
    user        => $user,
    group       => $group,
    cwd         => $home_dir,
    environment => [ "HOME=${home_dir}" ],
    onlyif      => '[ -n "$(which rbenv)" ]',
    path        => ["${root_dir}/${install_dir}/shims", "${root_dir}/${install_dir}/bin", '/bin', '/usr/local/bin', '/usr/bin', '/usr/sbin'],
    require     => Exec["install ruby ${user} ${ruby_version}"],
  }

  exec { "set-ruby_version $user":
    command     => "rbenv global ${ruby_version}",
    user        => $user,
    group       => $group,
    cwd         => $home_dir,
    environment => [ "HOME=${home_dir}" ],
    onlyif      => '[ -n "$(which rbenv)" ]',
    unless      => "grep ${ruby_version} ${root_dir}/${install_dir}/version 2>/dev/null",
    path        => ["${root_dir}/${install_dir}/shims", "${root_dir}/${install_dir}/bin", '/bin', '/usr/local/bin', '/usr/bin', '/usr/sbin'],
    require     => [Exec["install ruby ${user} ${ruby_version}"], Exec["rehash-rbenv $user"]],
  }
}
