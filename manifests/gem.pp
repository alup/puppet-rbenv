# Install a gem under rbenv for a certain user's ruby version.
# Requires rbenv::compile for the passed in user and ruby version
#
define rbenv::gem(
  $user,
  $ruby,
  $gem    = $title,
  $home   = "/home/$user",
  $root   = "${home}/.rbenv",
  $ensure = present,
) {

  if ! defined( Exec["rbenv::compile ${user} ${ruby}"] ) {
    fail("Rbenv-Ruby ${ruby} for user ${user} not found in catalog")
  }

  package {"rbenv::${user}/${ruby} :: ${gem}":
    ensure   => $ensure,
    provider => 'rbenvgem',
    root     => "${root}/versions/${ruby}"
  }
}
