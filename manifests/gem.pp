# Install a gem under rbenv for a certain user's ruby version.
# Title doesn't matter, just don't duplicate it
# Requires rbenv::compile for the passed in user and ruby version
define rbenv::gem($gemname, $foruser, $rubyversion, $gemversion = 'latest') {
  $gemcmd = "/home/$foruser/.rbenv/versions/$rubyversion/bin/gem"

  $version_assert = "[ -f $gemcmd ]"
 
  # determine if they need the requested version/update
  if( $gemversion == 'latest') {
    $unless = "$version_assert && $gemcmd outdated | grep -v $gemname"
    $installversion = ''
  } else {
    $unless = "$version_assert && $gemcmd list | grep $gemname | grep $gemversion"
    $installversion = "--version $gemversion"
  }

  # install specific version
  exec {
    "install rbenv gem $gemname in ruby $rubyversion for $foruser":
      command => "$gemcmd install $gemname --quiet --no-ri --no-rdoc $installversion",
      path    => [ "/home/$name/.rbenv/shims", "/home/$name/.rbenv/bin", '/usr/bin', '/bin'],
      user => $foruser,
      unless  => $unless,
      require => Rbenv::Compile["rbenv::compile::$foruser::$rubyversion"];
  }
}