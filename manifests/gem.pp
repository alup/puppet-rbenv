# Install a gem under rbenv for a certain user's ruby version.
# Title doesn't matter, just don't duplicate it
# Requires rbenv::compile for the passed in user and ruby version
define rbenv::gem($gemname, $foruser, $rubyversion, $gemversion) {
  $gemcmd = "/home/$foruser/.rbenv/versions/$rubyversion/bin/gem"

  $ruby_version_assert = "[ -f $gemcmd ]"
  $exec_path = [ "/home/$name/.rbenv/shims", "/home/$name/.rbenv/bin", '/usr/bin', '/bin']
 
  # determine if they need the requested version/update
  # if( $gemversion == 'latest') {
    # install latest version
  #   exec {
  #     "install rbenv gem $gemname $gemversion in ruby $rubyversion for $foruser":
  #       command => "$gemcmd install $gemname --quiet --no-ri --no-rdoc",
  #       path    => $exec_path,
  #       user    => $foruser,
  #       # install if: it's not installed at all OR it's in gem outdated
  #       onlyif  => [$ruby_version_assert, "bash -c '( ! $gemcmd -i $gemname ) || ( $gemcmd outdated | grep $gemname )'" 
  #       require => Rbenv::Compile["rbenv::compile::$foruser::$rubyversion"];
  #   }
  # } else {
    # install specific version
    exec {
      "install rbenv gem $gemname $gemversion in ruby $rubyversion for $foruser":
        command => "$gemcmd install $gemname --quiet --no-ri --no-rdoc --version $gemversion",
        path    => $exec_path,
        user    => $foruser,
        onlyif  => $ruby_version_assert,
        unless  => ["$gemcmd list -i -v'$gemversion' $gemname"],
        require => Rbenv::Compile["rbenv::compile::$foruser::$rubyversion"];
    # }
  }
}