class rbenv::paths($user, $home) {

  # Assign different values for shared install
  case $user {
    'root':  {
      $home =  '/root'
      $root = '/usr/local'
      $dest = 'rbenv'
    }
    default: {
      $root = $home
      $dest = '.rbenv'
    }
  }
}
