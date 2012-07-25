define rbenv::user( $foruser=$title, $group=$title, $home_dir="/home/${title}", $compile=true, $version='1.9.3-p194' ) {

  include rbenv::dependencies

  rbenv::install { "rbenv::install::${foruser}":
    user      => $foruser,
    group     => $group,
    home_dir  => $home_dir,
  }

  if $compile {
    rbenv::compile { "rbenv::compile::${foruser}::${version}":
      user         => $foruser,
      group        => $group,
      home_dir     => $home_dir,
      ruby_version => $version,
    }
  }

}
