# Install a gem under rbenv for a certain user's ruby version.
# Requires rbenv::compile for the passed in user and ruby version
#
define rbenv::gem(
  $user,
  $ruby,
  $gem    = $title,  
  $ensure = present,
) {

  if ! defined( Exec["rbenv::compile ${user} ${ruby}"] ) {
    fail("Rbenv-Ruby ${ruby} for user ${user} not found in catalog")
  }

  rbenvgem {"${user}/${ruby}/${gem}/${ensure}":
    ensure  => $ensure,
    user    => $user,
    gemname => $gem,    
    ruby => $ruby,    
    require => Exec["rbenv::compile ${user} ${ruby}"],
  }
}
