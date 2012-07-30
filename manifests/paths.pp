class rbenv::paths($user, $home) {

  # Assign different values for shared install
  case $user {
    'root':  {
      $home = '/root'
      $root = '/usr/local/rbenv'
    }
    default: {
      $root = "${home}/.rbenv"
    }
  }

  $bin            = "${root}/bin"
  $shims          = "${root}/shims"
  $plugins        = "${root}/plugins"
  $versions       = "${root}/versions"
  $global_version = "${root}/version"

}
